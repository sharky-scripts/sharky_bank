<script>
  import { history } from "../../store.js";

  const typeLabels = {
    deposit: "Betétel",
    withdraw: "Kifizetés",
    transfer: "Utalás (kimenő)",
    transfer_received: "Utalás (bejövő)",
  };

  function labelFor(row) {
    return typeLabels[row.type] || "—";
  }

  function amountFor(row) {
    if (!row || typeof row !== "object" || !("amount" in row)) return "—";
    const n = Number(row.amount);
    return Number.isFinite(n)
      ? new Intl.NumberFormat("hu-HU").format(Math.floor(n))
      : "—";
  }

  function dateFor(row) {
    if (!row || typeof row !== "object" || !("created_at" in row)) return "—";
    const raw = row.created_at;
    if (raw == null) return "—";
    return new Date(raw).toLocaleDateString("hu-HU", {
      hour: "2-digit",
      minute: "2-digit",
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
    });
  }
</script>

<h1
  class="mb-1 text-center text-[0.95rem] font-bold leading-tight tracking-wide"
>
  TRANZAKCIÓ ELŐZMÉNYEK
</h1>
<p class="mb-3 text-center text-[0.72rem] font-medium text-white/55">
  Legutóbbi műveletek a számládon.
</p>

{#if $history.length === 0}
  <div
    class="mt-1.5 rounded-sm bg-black/25 py-4 px-2.5 text-center text-[0.75rem] text-white/45"
  >
    Még nincs rögzített tranzakció.
  </div>
{:else}
  <ul
    class="mt-1 max-h-[min(40vh,280px)] list-none space-y-1.5 overflow-y-auto p-0 text-[0.72rem]"
  >
    {#each $history as row, i (row.id ?? i)}
      <li
        class="flex items-center justify-between gap-2 rounded-sm bg-black/30 px-2 py-1.5 text-white/90"
      >
        <span class="min-w-0 shrink font-medium text-[#e67e22]"
          >{labelFor(row)}</span
        >
        <span class="shrink-0 font-semibold tabular-nums">{amountFor(row)}</span
        >
        <span class="min-w-0 shrink-0 text-right text-white/50"
          >{dateFor(row)}</span
        >
      </li>
    {/each}
  </ul>
{/if}
