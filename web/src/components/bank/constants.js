/** Shared Tailwind class fragments for bank forms */
export const FIELD_CLASS =
  "box-border text-center w-full rounded-sm border-0 bg-black/45 py-2 px-2.5 text-[0.8rem] font-medium text-white outline-none transition-shadow placeholder:text-[0.78rem] placeholder:text-white/40 focus:shadow-[0_0_0_1px_rgba(230,126,34,0.45)] bg-zinc-800";

export const PRIMARY_BTN_CLASS =
  "mt-3 w-full cursor-pointer rounded-sm border-0 text-[#82cd26] bg-[#82cd26]/30 py-2.5 px-3 text-[0.82rem] font-bold tracking-wide text-[#0f0f0f] transition hover:brightness-110 active:scale-[0.99] disabled:cursor-not-allowed disabled:opacity-45 disabled:hover:brightness-100";

const NAV_CORE =
  "flex h-[34px] w-[34px] shrink-0 cursor-pointer items-center justify-center rounded border-2 text-[0.8rem] text-white transition-[background-color,border-color,transform] duration-150 hover:scale-[1.04] hover:bg-white/10";

export const NAV_SELECTED = `${NAV_CORE} border-transparent bg-[rgba(230,126,34,0.20)]`;
export const NAV_IDLE = `${NAV_CORE} border-transparent bg-[rgba(230,126,34,0.10)]`;
