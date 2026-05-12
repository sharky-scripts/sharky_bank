<script>
  import { createEventDispatcher } from "svelte";
  import { NAV_IDLE, NAV_SELECTED } from "./constants.js";

  /** @type {'transfer' | 'history' | 'withdraw' | 'deposit'} */
  export let activeTab;

  const dispatch = createEventDispatcher();
</script>

<aside
  class="flex w-[54px] shrink-0 flex-col items-center justify-between border-r border-white/[0.06] bg-[rgba(20,20,20,0.85)] py-2.5 pb-3"
>
  <nav class="flex flex-col items-center gap-2">
    <button
      type="button"
      class={activeTab === "transfer" ? NAV_SELECTED : NAV_IDLE}
      title="Utalás"
      aria-label="Utalás"
      on:click={() => dispatch("tab", "transfer")}
    >
      <i class="fa-solid fa-money-bill-transfer"></i>
    </button>
    <button
      type="button"
      class={activeTab === "history" ? NAV_SELECTED : NAV_IDLE}
      title="Tranzakció előzmények"
      aria-label="Előzmények"
      on:click={() => dispatch("tab", "history")}
    >
      <i class="fa-regular fa-clock"></i>
    </button>
    <button
      type="button"
      class={activeTab === "withdraw" ? NAV_SELECTED : NAV_IDLE}
      title="Pénz kifizetés"
      aria-label="Kifizetés"
      on:click={() => dispatch("tab", "withdraw")}
    >
      <span class="relative inline-flex items-center justify-center">
        <i class="fa-solid fa-wallet"></i>
        <i
          class="fa-solid fa-arrow-down absolute bottom-px -right-0.5 text-[0.45rem] [text-shadow:0_0_2px_#000]"
        ></i>
      </span>
    </button>
    <button
      type="button"
      class={activeTab === "deposit" ? NAV_SELECTED : NAV_IDLE}
      title="Pénz betétel"
      aria-label="Betétel"
      on:click={() => dispatch("tab", "deposit")}
    >
      <span class="relative inline-flex items-center justify-center">
        <i class="fa-solid fa-wallet"></i>
        <i
          class="fa-solid fa-arrow-up absolute bottom-px -right-0.5 text-[0.45rem] [text-shadow:0_0_2px_#000]"
        ></i>
      </span>
    </button>
  </nav>

  <button
    type="button"
    class="{NAV_IDLE} mt-auto text-white/85"
    title="Kilépés"
    aria-label="Bezárás"
    on:click={() => dispatch("close")}
  >
    <i class="fa-solid fa-power-off"></i>
  </button>
</aside>
