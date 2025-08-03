shader_type canvas_item;

// ── Parameters ──────────────────────────────────────────────
// Circle centre in UV space (0→1)
uniform vec2 center         = vec2(0.5, 0.5);

// Start/end angles (degrees), now from –360° to +360°
uniform float start_deg     : hint_range(-360.0, 360.0) = 0.0;
uniform float end_deg       : hint_range(-360.0, 360.0) = 90.0;

// Choose direction: false = CCW, true = CW
uniform bool  clockwise     = false;  // Godot supports `uniform bool` :contentReference[oaicite:0]{index=0}

// Tint colours
uniform vec4 inside_col     : source_color = vec4(1.0,1.0,1.0,1.0);
uniform vec4 outside_col    : source_color = vec4(0.0,0.0,0.0,1.0);

void fragment() {
    // 1️⃣ sample the sprite
    vec4 texc = texture(TEXTURE, UV);

    // 2️⃣ compute angle [0..2π)
    vec2 ofs = UV - center;
    float ang = atan(ofs.y, ofs.x);
    if (ang < 0.0) ang += TAU;

    // 3️⃣ convert deg→rad
    float s = radians(start_deg);
    float e = radians(end_deg);

    // 4️⃣ compute wedge sizes (always ≥0, <TAU)
    float d_ccw = mod(e - s + TAU, TAU);  // CCW span :contentReference[oaicite:1]{index=1}
    float d_cw  = mod(s - e + TAU, TAU);  // CW span

    // 5️⃣ test membership based on direction
    bool in_wedge;
    if (!clockwise) {
        // CCW: is (ang) within [s → s + d_ccw]?
        float diff = mod(ang - s + TAU, TAU);
        in_wedge = diff <= d_ccw;
    } else {
        // CW: is (ang) within [s → s - d_cw] going clockwise?
        float diff = mod(s - ang + TAU, TAU);
        in_wedge = diff <= d_cw;
    }

    // 6️⃣ apply tint
    vec4 tint = in_wedge ? inside_col : outside_col;
    COLOR = texc * tint;
}
