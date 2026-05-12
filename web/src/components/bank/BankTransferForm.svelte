<script>
  import { createEventDispatcher } from "svelte";
  import { notify } from "../../store.js";
  import { FIELD_CLASS, PRIMARY_BTN_CLASS } from "./constants.js";

  export let amount = "";
  export let target = "";
  export let submitting = false;

  const dispatch = createEventDispatcher();

  function submit() {
    const raw = String(amount).replace(/\s/g, "").replace(/\./g, "");
    const n = parseInt(raw, 10);
    const targetId = parseInt(String(target).trim(), 10);
    if (!Number.isFinite(n) || n <= 0) {
      notify("Adj meg érvényes összeget (0-nál nagyobb).", "error");
      return;
    }
    if (!Number.isFinite(targetId) || targetId <= 0) {
      notify(
        "Adj meg érvényes cél szerver ID-t (pozitív egész szám).",
        "error",
      );
      return;
    }
    dispatch("submit", { amount: n, target: targetId });
  }
</script>

<h1
  class="mb-1 text-center text-[0.95rem] font-bold leading-tight tracking-wide"
>
  UTALÁS
</h1>
<p class="mb-3 text-center text-[0.72rem] font-medium text-white/[0.88]">
  A másik játékos <span class="font-semibold text-[#e67e22]">szerver ID</span
  >-jára utalsz.
</p>
<input
  class={FIELD_CLASS}
  type="text"
  inputmode="numeric"
  placeholder="Összeg megadása"
  bind:value={amount}
/>
<input
  class="{FIELD_CLASS} mt-2"
  type="text"
  inputmode="numeric"
  placeholder="Cél játékos szerver ID (pl. 12)"
  bind:value={target}
/>
<button
  type="button"
  class={PRIMARY_BTN_CLASS}
  disabled={submitting}
  on:click={submit}
>
  {submitting ? "Küldés…" : "Utalás indítása"}
</button>
