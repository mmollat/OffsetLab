"use client";

import { useState } from "react";
import { supabase } from "../lib/supabase";

type Props = {
  open: boolean;
  onClose: () => void;
  defaults: {
    year: string;
    make: string;
    model: string;
    trim: string;
    fitmentStyle: string;
    frontWheel: string;
    rearWheel: string;
    frontTire: string;
    rearTire: string;
  };
};

export default function SubmitBuildModal({ open, onClose, defaults }: Props) {
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState("");
  const [form, setForm] = useState({
    name: "",
    email: "",
    instagram: "",
    year: defaults.year,
    make: defaults.make,
    model: defaults.model,
    trim: defaults.trim,
    fitmentStyle: defaults.fitmentStyle,
    frontWheel: defaults.frontWheel,
    rearWheel: defaults.rearWheel,
    frontTire: defaults.frontTire,
    rearTire: defaults.rearTire,
    suspension: "",
    notes: "",
    file: null as File | null,
  });

  if (!open) return null;

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      let imageUrl = "";

      if (form.file) {
        const ext = form.file.name.split(".").pop();
        const filePath = `submissions/${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`;
        const { error: uploadError } = await supabase.storage
          .from("build-photos")
          .upload(filePath, form.file);

        if (uploadError) throw uploadError;

        const { data } = supabase.storage.from("build-photos").getPublicUrl(filePath);
        imageUrl = data.publicUrl;
      }

      const { error: insertError } = await supabase.from("build_submissions").insert({
        status: "pending",
        make: form.make,
        model: form.model,
        trim: form.trim,
        year: form.year,
        fitment_style: form.fitmentStyle,
        front_wheel: form.frontWheel,
        rear_wheel: form.rearWheel,
        front_tire: form.frontTire,
        rear_tire: form.rearTire,
        suspension: form.suspension,
        notes: form.notes,
        image_url: imageUrl,
        submitter_name: form.name,
        submitter_email: form.email,
        instagram_handle: form.instagram,
      });

      if (insertError) throw insertError;
      setSuccess(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Submission failed");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4">
      <div className="w-full max-w-2xl rounded-3xl border border-white/10 bg-[#0b0d11] p-6 text-white">
        <div className="mb-4 flex items-center justify-between">
          <h2 className="text-2xl font-bold">Submit Your Build</h2>
          <button onClick={onClose} className="text-white/60 hover:text-white">Close</button>
        </div>

        {success ? (
          <div className="rounded-2xl border border-emerald-400/30 bg-emerald-400/10 p-5 text-emerald-200">
            Build submitted — we’ll review it before adding it to the gallery.
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="grid gap-4 md:grid-cols-2">
              <Input label="Name" value={form.name} onChange={(v) => setForm({ ...form, name: v })} required />
              <Input label="Email" type="email" value={form.email} onChange={(v) => setForm({ ...form, email: v })} required />
              <Input label="Instagram" value={form.instagram} onChange={(v) => setForm({ ...form, instagram: v })} />
              <Input label="Year" value={form.year} onChange={(v) => setForm({ ...form, year: v })} />
              <Input label="Make" value={form.make} onChange={(v) => setForm({ ...form, make: v })} />
              <Input label="Model" value={form.model} onChange={(v) => setForm({ ...form, model: v })} />
              <Input label="Trim" value={form.trim} onChange={(v) => setForm({ ...form, trim: v })} />
              <Input label="Fitment Style" value={form.fitmentStyle} onChange={(v) => setForm({ ...form, fitmentStyle: v })} />
              <Input label="Front Wheel" value={form.frontWheel} onChange={(v) => setForm({ ...form, frontWheel: v })} />
              <Input label="Rear Wheel" value={form.rearWheel} onChange={(v) => setForm({ ...form, rearWheel: v })} />
              <Input label="Front Tire" value={form.frontTire} onChange={(v) => setForm({ ...form, frontTire: v })} />
              <Input label="Rear Tire" value={form.rearTire} onChange={(v) => setForm({ ...form, rearTire: v })} />
              <Input label="Suspension" value={form.suspension} onChange={(v) => setForm({ ...form, suspension: v })} />
            </div>

            <div>
              <label className="mb-2 block text-sm text-white/60">Notes</label>
              <textarea
                value={form.notes}
                onChange={(e) => setForm({ ...form, notes: e.target.value })}
                className="min-h-28 w-full rounded-2xl border border-white/10 bg-black/30 px-4 py-3 outline-none"
              />
            </div>

            <div>
              <label className="mb-2 block text-sm text-white/60">Build Photo</label>
              <input
                type="file"
                accept="image/*"
                onChange={(e) => setForm({ ...form, file: e.target.files?.[0] ?? null })}
                className="w-full rounded-2xl border border-white/10 bg-black/30 px-4 py-3"
              />
            </div>

            {error ? <p className="text-sm text-red-300">{error}</p> : null}

            <button
              type="submit"
              disabled={loading}
              className="w-full rounded-2xl bg-emerald-400 px-5 py-3 font-bold text-black hover:bg-emerald-300 disabled:opacity-60"
            >
              {loading ? "Submitting..." : "Submit Build"}
            </button>
          </form>
        )}
      </div>
    </div>
  );
}

function Input({
  label,
  value,
  onChange,
  required = false,
  type = "text",
}: {
  label: string;
  value: string;
  onChange: (value: string) => void;
  required?: boolean;
  type?: string;
}) {
  return (
    <div>
      <label className="mb-2 block text-sm text-white/60">{label}</label>
      <input
        type={type}
        required={required}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="w-full rounded-2xl border border-white/10 bg-black/30 px-4 py-3 outline-none"
      />
    </div>
  );
}
