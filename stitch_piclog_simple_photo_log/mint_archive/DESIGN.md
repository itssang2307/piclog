# Design System Strategy: The Lucid Interface

## 1. Overview & Creative North Star: "The Digital Atrium"
This design system rejects the "boxed-in" nature of traditional bulletin boards. Instead, it adopts the **Creative North Star of "The Digital Atrium."** Like a glass-walled gallery filled with natural light, the UI prioritizes breathing room, environmental transparency, and a sense of weightlessness.

We move beyond the "template" look by utilizing **intentional asymmetry**—where text-only posts might have generous, offset padding while image posts bleed into the margins. By utilizing high-contrast typography scales (the massive jump between `display` and `label` tokens), we create an editorial rhythm that feels like a premium digital magazine rather than a static list of data.

---

## 2. Colors: Tonal Architecture
The palette is built on a foundation of "Fresh Mint" and "Ethereal Grays." Our goal is to create a UI that feels like it’s rendered on silk rather than a screen.

*   **The "No-Line" Rule:** 1px solid borders are strictly prohibited for defining sections. Structure must be achieved through **Background Color Shifts**. For instance, a main feed container (`surface-container-low`) sits on the global `background` without a divider.
*   **Surface Hierarchy & Nesting:** Use the `surface-container` tiers to create organic depth. 
    *   Place a `surface-container-lowest` card (pure white) on a `surface-container` background to create a "lifted" effect.
    *   Nest `surface-container-high` elements within a card for meta-information or tags to create an "inset" focus.
*   **The "Glass & Gradient" Rule:** For floating navigation or top bars, use `surface` tokens at 80% opacity with a `backdrop-blur` of 20px. 
*   **Signature Textures:** Main CTAs should not be flat. Apply a subtle linear gradient from `primary` (#006b64) to `primary_container` (#79f7ea) at a 135-degree angle to give the "Fresh and Light" identity a tactile, glowing soul.

---

## 3. Typography: Editorial Clarity
We use a dual-font approach to balance personality with extreme readability.

*   **Headlines (Plus Jakarta Sans):** Used for `display` and `headline` scales. This typeface provides a modern, slightly wide stance that feels welcoming and premium.
*   **Body & Labels (Be Vietnam Pro):** Used for `title`, `body`, and `label`. It is a workhorse font that maintains high legibility in the Korean-specific context (Pretendard/Noto Sans KR fallbacks) while appearing lighter and more sophisticated than standard system fonts.
*   **Hierarchy as Identity:** The vast difference between a `display-lg` (3.5rem) page header and a `label-sm` (0.6875rem) timestamp creates an authoritative visual anchor, guiding the user's eye without the need for icons or arrows.

---

## 4. Elevation & Depth: Atmospheric Layering
Forget drop shadows that look like "fuzz." We use **Tonal Layering** to define the Z-axis.

*   **The Layering Principle:** Depth is "stacked." 
    *   Level 0: `background` (#f8fafb)
    *   Level 1: `surface-container-low` (The "Canvas")
    *   Level 2: `surface-container-lowest` (The "Content Card")
*   **Ambient Shadows:** If a card must float (e.g., a "Create Post" button), use a 24px blur with 6% opacity, using the `on-surface` color (#2c3436) as the shadow tint. It should look like a soft glow, not a dark stain.
*   **The "Ghost Border" Fallback:** If accessibility requires a border, use `outline-variant` at 15% opacity. Never use 100% opaque lines; they "shatter" the lightness of the atrium.
*   **Glassmorphism:** Use `surface_bright` with semi-transparency for overlays to allow the brand's soft mint and blue tones to bleed through from underlying layers.

---

## 5. Components: Fluid Primitives

*   **Cards (The Post):** Forbid divider lines. Separate the "Author" header from the "Content" body using a `2rem` vertical spacing (`xl` spacing scale). For image posts, use the `lg` (1rem) corner radius.
*   **Buttons:**
    *   *Primary:* Gradient fill (Primary to Primary-Container) with `full` (pill-shaped) roundedness.
    *   *Secondary:* `surface-container-highest` background with `on-surface` text. No border.
*   **Input Fields:** Use `surface-container-low` as the field background. Upon focus, transition to `surface-container-lowest` with a "Ghost Border" of `primary` at 20% opacity.
*   **Chips (Categories):** Use `secondary_container` for the background and `on_secondary_container` for text. Use `sm` (0.25rem) radius for a "technical" look that contrasts with the "soft" brand.
*   **The "Contextual Post" Component:** For text-only posts, use a larger `title-lg` font for the content to fill the visual void. For image+text, the image takes the `surface-variant` background as a placeholder to ensure the layout doesn't "jump" during loading.

---

## 6. Do’s and Don’ts

### Do:
*   **Embrace Negative Space:** If you think there’s enough white space, add 20% more. Space is a luxury.
*   **Use Asymmetric Padding:** Align text to the left but allow images to extend to the container edge to break the "grid-block" feel.
*   **Subtle Transitions:** Every hover state should be a soft 200ms transition of the background color, never a sudden "snap."

### Don’t:
*   **Don't use pure black (#000):** Use `on_surface` (#2c3436) for all text to maintain the "Fresh and Light" softness.
*   **Don't use 1px Dividers:** Use vertical margin or a `surface` color shift to separate thoughts and sections.
*   **Don't crowd the edges:** Elements should never touch the edge of their parent container; maintain at least `md` (0.75rem) padding at all times.