shader_type canvas_item;

// Radius that the shader was designed for.
const float DEFAULT_RADIUS = 100.000000000;

// Unit vector: (1, 0) or (0, 1)
uniform vec2 step;
// Desired blur radius.
uniform float radius = 100.000000000;

void fragment() {
	vec2 s = radius / DEFAULT_RADIUS * step / vec2(textureSize(TEXTURE, 0));
	COLOR.rgb =
		0.001107605 * texture(TEXTURE, UV - 100.500000000 * s).rgb +
		0.002352181 * texture(TEXTURE, UV - 98.990101294 * s).rgb +
		0.002543993 * texture(TEXTURE, UV - 96.990301217 * s).rgb +
		0.002747049 * texture(TEXTURE, UV - 94.990501143 * s).rgb +
		0.002961571 * texture(TEXTURE, UV - 92.990701072 * s).rgb +
		0.003187741 * texture(TEXTURE, UV - 90.990901005 * s).rgb +
		0.003425698 * texture(TEXTURE, UV - 88.991100940 * s).rgb +
		0.003675533 * texture(TEXTURE, UV - 86.991300878 * s).rgb +
		0.003937285 * texture(TEXTURE, UV - 84.991500819 * s).rgb +
		0.004210935 * texture(TEXTURE, UV - 82.991700762 * s).rgb +
		0.004496404 * texture(TEXTURE, UV - 80.991900709 * s).rgb +
		0.004793552 * texture(TEXTURE, UV - 78.992100657 * s).rgb +
		0.005102167 * texture(TEXTURE, UV - 76.992300609 * s).rgb +
		0.005421971 * texture(TEXTURE, UV - 74.992500562 * s).rgb +
		0.005752609 * texture(TEXTURE, UV - 72.992700519 * s).rgb +
		0.006093653 * texture(TEXTURE, UV - 70.992900477 * s).rgb +
		0.006444597 * texture(TEXTURE, UV - 68.993100438 * s).rgb +
		0.006804857 * texture(TEXTURE, UV - 66.993300401 * s).rgb +
		0.007173770 * texture(TEXTURE, UV - 64.993500366 * s).rgb +
		0.007550594 * texture(TEXTURE, UV - 62.993700333 * s).rgb +
		0.007934507 * texture(TEXTURE, UV - 60.993900303 * s).rgb +
		0.008324612 * texture(TEXTURE, UV - 58.994100274 * s).rgb +
		0.008719935 * texture(TEXTURE, UV - 56.994300247 * s).rgb +
		0.009119430 * texture(TEXTURE, UV - 54.994500222 * s).rgb +
		0.009521982 * texture(TEXTURE, UV - 52.994700198 * s).rgb +
		0.009926410 * texture(TEXTURE, UV - 50.994900177 * s).rgb +
		0.010331473 * texture(TEXTURE, UV - 48.995100157 * s).rgb +
		0.010735876 * texture(TEXTURE, UV - 46.995300138 * s).rgb +
		0.011138275 * texture(TEXTURE, UV - 44.995500121 * s).rgb +
		0.011537283 * texture(TEXTURE, UV - 42.995700106 * s).rgb +
		0.011931482 * texture(TEXTURE, UV - 40.995900092 * s).rgb +
		0.012319425 * texture(TEXTURE, UV - 38.996100079 * s).rgb +
		0.012699647 * texture(TEXTURE, UV - 36.996300068 * s).rgb +
		0.013070677 * texture(TEXTURE, UV - 34.996500057 * s).rgb +
		0.013431042 * texture(TEXTURE, UV - 32.996700048 * s).rgb +
		0.013779281 * texture(TEXTURE, UV - 30.996900040 * s).rgb +
		0.014113950 * texture(TEXTURE, UV - 28.997100033 * s).rgb +
		0.014433638 * texture(TEXTURE, UV - 26.997300026 * s).rgb +
		0.014736971 * texture(TEXTURE, UV - 24.997500021 * s).rgb +
		0.015022625 * texture(TEXTURE, UV - 22.997700016 * s).rgb +
		0.015289337 * texture(TEXTURE, UV - 20.997900012 * s).rgb +
		0.015535909 * texture(TEXTURE, UV - 18.998100009 * s).rgb +
		0.015761222 * texture(TEXTURE, UV - 16.998300007 * s).rgb +
		0.015964242 * texture(TEXTURE, UV - 14.998500004 * s).rgb +
		0.016144028 * texture(TEXTURE, UV - 12.998700003 * s).rgb +
		0.016299742 * texture(TEXTURE, UV - 10.998900002 * s).rgb +
		0.016430650 * texture(TEXTURE, UV - 8.999100001 * s).rgb +
		0.016536132 * texture(TEXTURE, UV - 6.999300000 * s).rgb +
		0.016615689 * texture(TEXTURE, UV - 4.999500000 * s).rgb +
		0.016668939 * texture(TEXTURE, UV - 2.999700000 * s).rgb +
		0.016695628 * texture(TEXTURE, UV - 0.999900000 * s).rgb +
		0.016695628 * texture(TEXTURE, UV + 0.999900000 * s).rgb +
		0.016668939 * texture(TEXTURE, UV + 2.999700000 * s).rgb +
		0.016615689 * texture(TEXTURE, UV + 4.999500000 * s).rgb +
		0.016536132 * texture(TEXTURE, UV + 6.999300000 * s).rgb +
		0.016430650 * texture(TEXTURE, UV + 8.999100001 * s).rgb +
		0.016299742 * texture(TEXTURE, UV + 10.998900002 * s).rgb +
		0.016144028 * texture(TEXTURE, UV + 12.998700003 * s).rgb +
		0.015964242 * texture(TEXTURE, UV + 14.998500004 * s).rgb +
		0.015761222 * texture(TEXTURE, UV + 16.998300007 * s).rgb +
		0.015535909 * texture(TEXTURE, UV + 18.998100009 * s).rgb +
		0.015289337 * texture(TEXTURE, UV + 20.997900012 * s).rgb +
		0.015022625 * texture(TEXTURE, UV + 22.997700016 * s).rgb +
		0.014736971 * texture(TEXTURE, UV + 24.997500021 * s).rgb +
		0.014433638 * texture(TEXTURE, UV + 26.997300026 * s).rgb +
		0.014113950 * texture(TEXTURE, UV + 28.997100033 * s).rgb +
		0.013779281 * texture(TEXTURE, UV + 30.996900040 * s).rgb +
		0.013431042 * texture(TEXTURE, UV + 32.996700048 * s).rgb +
		0.013070677 * texture(TEXTURE, UV + 34.996500057 * s).rgb +
		0.012699647 * texture(TEXTURE, UV + 36.996300068 * s).rgb +
		0.012319425 * texture(TEXTURE, UV + 38.996100079 * s).rgb +
		0.011931482 * texture(TEXTURE, UV + 40.995900092 * s).rgb +
		0.011537283 * texture(TEXTURE, UV + 42.995700106 * s).rgb +
		0.011138275 * texture(TEXTURE, UV + 44.995500121 * s).rgb +
		0.010735876 * texture(TEXTURE, UV + 46.995300138 * s).rgb +
		0.010331473 * texture(TEXTURE, UV + 48.995100157 * s).rgb +
		0.009926410 * texture(TEXTURE, UV + 50.994900177 * s).rgb +
		0.009521982 * texture(TEXTURE, UV + 52.994700198 * s).rgb +
		0.009119430 * texture(TEXTURE, UV + 54.994500222 * s).rgb +
		0.008719935 * texture(TEXTURE, UV + 56.994300247 * s).rgb +
		0.008324612 * texture(TEXTURE, UV + 58.994100274 * s).rgb +
		0.007934507 * texture(TEXTURE, UV + 60.993900303 * s).rgb +
		0.007550594 * texture(TEXTURE, UV + 62.993700333 * s).rgb +
		0.007173770 * texture(TEXTURE, UV + 64.993500366 * s).rgb +
		0.006804857 * texture(TEXTURE, UV + 66.993300401 * s).rgb +
		0.006444597 * texture(TEXTURE, UV + 68.993100438 * s).rgb +
		0.006093653 * texture(TEXTURE, UV + 70.992900477 * s).rgb +
		0.005752609 * texture(TEXTURE, UV + 72.992700519 * s).rgb +
		0.005421971 * texture(TEXTURE, UV + 74.992500562 * s).rgb +
		0.005102167 * texture(TEXTURE, UV + 76.992300609 * s).rgb +
		0.004793552 * texture(TEXTURE, UV + 78.992100657 * s).rgb +
		0.004496404 * texture(TEXTURE, UV + 80.991900709 * s).rgb +
		0.004210935 * texture(TEXTURE, UV + 82.991700762 * s).rgb +
		0.003937285 * texture(TEXTURE, UV + 84.991500819 * s).rgb +
		0.003675533 * texture(TEXTURE, UV + 86.991300878 * s).rgb +
		0.003425698 * texture(TEXTURE, UV + 88.991100940 * s).rgb +
		0.003187741 * texture(TEXTURE, UV + 90.990901005 * s).rgb +
		0.002961571 * texture(TEXTURE, UV + 92.990701072 * s).rgb +
		0.002747049 * texture(TEXTURE, UV + 94.990501143 * s).rgb +
		0.002543993 * texture(TEXTURE, UV + 96.990301217 * s).rgb +
		0.002352181 * texture(TEXTURE, UV + 98.990101294 * s).rgb;
	COLOR.a = 1.0;
}
