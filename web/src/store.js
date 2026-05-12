import { writable } from "svelte/store";
import { postNui } from "./lib/nui.js";

export const visible = writable(false);
export const balance = writable(0);
export const currency = writable("");
export const history = writable([]);

function normalizeHistory(rows) {
  if (!Array.isArray(rows)) return [];
  return [...rows].sort((a, b) => {
    const idA = Number(a?.id) || 0;
    const idB = Number(b?.id) || 0;
    return idB - idA;
  });
}

export function notify(message, type) {
  postNui("notify", { message, type });
}

window.addEventListener("message", function (event) {
  const data = event.data;
  if (!data || typeof data !== "object") return;

  if (data.type === "openBank") {
    visible.set(data.state === true);
    if (data.currentBalance != null) {
      balance.set(Number(data.currentBalance) || 0);
    }
    if (data.currency != null) {
      currency.set(String(data.currency));
    }
    history.set(normalizeHistory(data.history));
  }

  if (data.type === "closeBank") {
    visible.set(data.state);
    history.set([]);
  }

  if (data.type === "updateAccount") {
    if (data.currentBalance != null) {
      balance.set(Number(data.currentBalance) || 0);
    }
    if (data.history != null) {
      history.set(normalizeHistory(data.history));
    }
  }

  if (data.type === "updateBalance" && data.newBalance != null) {
    balance.set(Number(data.newBalance) || 0);
  }

  if (data.visible !== undefined) visible.set(!!data.visible);
});
