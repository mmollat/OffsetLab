import { supabase } from "./supabase";

export type VehicleModel = {
  make: string;
  model: string;
  active: boolean;
  sort_order: number;
  display_name?: string | null; // 👈 ADD THIS
};

export async function getVehicleModels(): Promise<VehicleModel[]> {
  const { data, error } = await supabase
    .from("vehicle_models")
    .select("make, model, active, sort_order, display_name") // 👈 BE EXPLICIT
    .eq("active", true)
    .order("sort_order", { ascending: true });

  if (error) {
    console.error("Error fetching vehicle models:", error);
    return [];
  }

  return data as VehicleModel[];
}
