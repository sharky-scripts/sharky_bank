<script>
  import { createEventDispatcher } from "svelte";
  import { notify, currency } from "../../store.js";
  import { FIELD_CLASS, PRIMARY_BTN_CLASS } from "./constants.js";

  export let title;
  export let amount = "";
  export let placeholder = "Kívánt összeg megadása";
  export let buttonLabel;
  export let submitting = false;

  const dispatch = createEventDispatcher();

  function submit() {
    const raw = String(amount).replace(/\s/g, "").replace(/\./g, "");
    const n = parseInt(raw, 10);
    if (!Number.isFinite(n) || n <= 0) {
      notify("Adj meg érvényes összeget (0-nál nagyobb).", "error");
      return;
    }
    dispatch("submit", { amount: n });
  }
</script>

<h1
  class="mb-1 text-center text-[0.95rem] font-bold leading-tight tracking-wide"
>
  {title}
</h1>
<p class="text-center text-[0.72rem] font-medium text-white/[0.88] mb-4">
  Azaz: <span class="font-bold">{Intl.NumberFormat("hu-HU").format(amount)} {$currency}</span>
</p>
<input
  class={FIELD_CLASS}
  type="text"
  inputmode="numeric"
  {placeholder}
  bind:value={amount}
/>
<button
  type="button"
  class={PRIMARY_BTN_CLASS}
  disabled={submitting}
  on:click={submit}
>
  {submitting ? "Küldés…" : buttonLabel}
</button>
