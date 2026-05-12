<script>
  import { onMount } from "svelte";
  import { visible, balance, notify, currency, history } from "./store.js";
  import { postNui } from "./lib/nui.js";
  import BankHeader from "./components/bank/BankHeader.svelte";
  import BankSidebar from "./components/bank/BankSidebar.svelte";
  import BankAmountForm from "./components/bank/BankAmountForm.svelte";
  import BankTransferForm from "./components/bank/BankTransferForm.svelte";
  import BankHistoryPanel from "./components/bank/BankHistoryPanel.svelte";

  /** @type {'transfer' | 'history' | 'withdraw' | 'deposit'} */
  let activeTab = "withdraw";
  let amount = "";
  let transferTarget = "";
  let submitting = false;

  async function send(endpoint, body) {
    if (submitting) return;
    submitting = true;
    try {
      await postNui(endpoint, body);
    } catch {
      notify("Nem sikerült kapcsolódni a klienshez.", "error");
    } finally {
      setTimeout(() => {
        submitting = false;
      }, 400);
    }
  }

  async function closeUi() {
    try {
      await postNui("close", {});
    } catch {
      /* still close locally */
    }
  }

  /** @param {'transfer' | 'history' | 'withdraw' | 'deposit'} tab */
  function selectTab(tab) {
    activeTab = tab;
    amount = "";
    transferTarget = "";
  }

  onMount(() => {
    if (import.meta.env.DEV) {
      visible.set(false);
      balance.set(0);
      currency.set("Ft");
      history.set([]);
    }
  });
</script>

<svelte:head>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link
    href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
    rel="stylesheet"
  />
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"
    integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg=="
    crossorigin="anonymous"
    referrerpolicy="no-referrer"
  />
</svelte:head>

<svelte:window on:keydown={(e) => e.key === "Escape" && closeUi()} />

{#if $visible}
  <div
    class="fixed inset-0 z-50 flex items-center justify-center p-[min(20px,3vw)] font-[Poppins,sans-serif] text-white"
  >
    <div
      class="pointer-events-none absolute inset-0 z-0"
      aria-hidden="true"
    ></div>

    <div
      class="relative z-[2] flex max-h-[min(98vh,680px)] min-h-[400px] w-[min(720px,calc(100vw-24px))] flex-col overflow-hidden rounded border border-white/10 bg-zinc-900 shadow-[0_16px_48px_rgba(0,0,0,0.55)]"
    >
      <BankHeader />
      <div class="relative flex min-h-0 flex-1 overflow-hidden">
        <BankSidebar
          {activeTab}
          on:tab={(e) => selectTab(e.detail)}
          on:close={closeUi}
        />

        <main
          class="flex min-h-0 min-w-0 flex-1 items-center justify-center overflow-y-auto px-2.5 pb-3 pt-2.5"
        >
          <div
            class="box-border flex w-full flex-col bg-[rgba(20,20,20,0.75)] px-3 pb-3 pt-3.5"
          >
            {#if activeTab === "withdraw"}
              <BankAmountForm
                title="PÉNZ KIFIZETÉS"
                bind:amount
                buttonLabel="Kifizetés"
                {submitting}
                on:submit={(e) => send("withdraw", e.detail)}
              />
            {:else if activeTab === "deposit"}
              <BankAmountForm
                title="PÉNZ BETÉTEL"
                bind:amount
                buttonLabel="Betétel"
                {submitting}
                on:submit={(e) => send("deposit", e.detail)}
              />
            {:else if activeTab === "transfer"}
              <BankTransferForm
                bind:amount
                bind:target={transferTarget}
                {submitting}
                on:submit={(e) => send("transfer", e.detail)}
              />
            {:else}
              <BankHistoryPanel />
            {/if}
          </div>
        </main>
      </div>
    </div>
  </div>
{/if}
