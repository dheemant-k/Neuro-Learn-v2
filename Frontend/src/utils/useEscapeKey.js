import { useEffect, useRef } from "react";

/** Calls onEscape when Escape is pressed while `active` (e.g. while a dialog is open). */
export function useEscapeKey(active, onEscape) {
  const handlerRef = useRef(onEscape);
  useEffect(() => {
    handlerRef.current = onEscape;
  });
  useEffect(() => {
    if (!active) return undefined;
    const onKeyDown = (e) => {
      if (e.key === "Escape") handlerRef.current();
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [active]);
}
