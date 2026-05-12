<script>
  import { balance, currency } from "../../store.js";

  $: formatted = new Intl.NumberFormat("hu-HU").format(
    Math.floor(Number($balance) || 0),
  );
  $: unit = $currency || "Ft";
</script>

<header
  class="flex min-h-9 shrink-0 items-center justify-center border-b border-white/[0.06] bg-[rgba(20,20,20,0.9)] px-2.5 pb-2 pt-2"
>
  <p
    class="m-0 text-center text-[0.78rem] font-medium leading-tight tracking-wide"
  >
    Számlán lévő egyenleg: <span class="font-bold">{formatted}</span>
    {unit}
  </p>
</header>