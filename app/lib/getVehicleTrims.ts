import { supabase } from "./supabase";

export type VehicleTrim = {
  make: string;
  model: string;
  trim: string;
  active: boolean;
  sort_order: number;
};

export async function getVehicleTrims(): Promise<VehicleTrim[]> {
  const { data, error } = await supabase
    .from("vehicle_trims")
    .select("*")
    .eq("active", true)
    .order("sort_order", { ascending: true });

  if (error) {
    console.error("Error fetching vehicle trims:", error);
    return [];
  }

  return data as VehicleTrim[];
}
