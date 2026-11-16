export function factoryTireLabel(front: string, rear: string) {
  return front === rear ? front : `${front} front / ${rear} rear`;
}
