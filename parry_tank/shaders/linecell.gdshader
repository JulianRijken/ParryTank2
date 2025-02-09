shader_type canvas_item;

uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;
uniform sampler2D gradient: hint_default_black;
uniform float depth = 0.03;
uniform int line_thickness = 7;

void fragment() {
    vec3 color = texture(screen_texture,SCREEN_UV).rgb;
    float grayscale_value = dot(color, vec3(0.299, 0.587, 0.114));
    if (int(VERTEX.x+VERTEX.y)%(2*line_thickness) < line_thickness){
        grayscale_value -= depth;
        }
    
    vec3 sampled_color = texture(gradient, vec2(grayscale_value, 0.0)).rgb;
    
    COLOR.rgb = sampled_color;
}
