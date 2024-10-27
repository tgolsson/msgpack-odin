import re

import pandas as pd

# Sample input data string
data = """
[small_mpack_unpack] 100 rounds, 22 K(B/items) processed in 3 ms
                33200.046 rounds/s, 6.966 MiB/s

[medium_mpack_unpack] 100 rounds, 220 K(B/items) processed in 30 ms
                3292.074 rounds/s, 6.907 MiB/s

[large_mpack_unpack] 100 rounds, 2200 K(B/items) processed in 342 ms
                291.781 rounds/s, 6.122 MiB/s

[massive_mpack_unpack] 100 rounds, 11000 K(B/items) processed in 1762 ms
                56.738 rounds/s, 5.952 MiB/s

[small_cbor_unpack] 100 rounds, 22 K(B/items) processed in 5 ms
                17779.127 rounds/s, 3.730 MiB/s

[medium_cbor_unpack] 100 rounds, 220 K(B/items) processed in 54 ms
                1831.662 rounds/s, 3.843 MiB/s

[large_cbor_unpack] 100 rounds, 2200 K(B/items) processed in 641 ms
                155.994 rounds/s, 3.273 MiB/s

[massive_cbor_unpack] 100 rounds, 11000 K(B/items) processed in 2965 ms
                33.719 rounds/s, 3.537 MiB/s

[small_json_unpack] 100 rounds, 22 K(B/items) processed in 52 ms
                1914.856 rounds/s, 0.402 MiB/s

[medium_json_unpack] 100 rounds, 220 K(B/items) processed in 472 ms
                211.728 rounds/s, 0.444 MiB/s

[large_json_unpack] 100 rounds, 2200 K(B/items) processed in 5015 ms
                19.940 rounds/s, 0.418 MiB/s

[massive_json_unpack] 100 rounds, 11000 K(B/items) processed in 25285 ms
                3.955 rounds/s, 0.415 MiB/s


[small_cbor_pack] 100 rounds, 922 K(B/items) processed in 5 ms
                18812.315 rounds/s, 165.450 MiB/s

[medium_cbor_pack] 100 rounds, 9324 K(B/items) processed in 34 ms
                2927.024 rounds/s, 260.278 MiB/s

[large_cbor_pack] 100 rounds, 93532 K(B/items) processed in 403 ms
                248.002 rounds/s, 221.216 MiB/s

[massive_cbor_pack] 100 rounds, 467799 K(B/items) processed in 1747 ms
                57.227 rounds/s, 255.307 MiB/s

[small_json_pack] 100 rounds, 1818 K(B/items) processed in 17 ms
                5811.172 rounds/s, 100.770 MiB/s

[medium_json_pack] 100 rounds, 18273 K(B/items) processed in 177 ms
                564.070 rounds/s, 98.302 MiB/s

[large_json_pack] 100 rounds, 183861 K(B/items) processed in 1862 ms
                53.683 rounds/s, 94.129 MiB/s

[massive_json_pack] 100 rounds, 923991 K(B/items) processed in 9170 ms
                10.905 rounds/s, 96.091 MiB/s

[small_mpack_pack] 100 rounds, 914 K(B/items) processed in 1 ms
                73365.365 rounds/s, 639.775 MiB/s

[medium_mpack_pack] 100 rounds, 9316 K(B/items) processed in 13 ms
                7227.304 rounds/s, 642.160 MiB/s

[large_mpack_pack] 100 rounds, 93552 K(B/items) processed in 142 ms
                701.517 rounds/s, 625.880 MiB/s

[massive_mpack_pack] 100 rounds, 467931 K(B/items) processed in 822 ms
                121.649 rounds/s, 542.862 MiB/s"""

data2 = """
[small_json_pack] 100 rounds, 2750 K(B/items) processed in 3 ms
                28120.235 rounds/s, 773.4470739048502 MiB/s

[small_json_unpack] 100 rounds, 22 K(B/items) processed in 4 ms
                23101.955 rounds/s, 635.4192711748628 MiB/s

[small_cbor_pack] 100 rounds, 1403 K(B/items) processed in 5 ms
                18280.914 rounds/s, 256.5543472177003 MiB/s

[small_cbor_unpack] 100 rounds, 22 K(B/items) processed in 6 ms
                15548.528 rounds/s, 218.20804152029433 MiB/s

[small_mpack_pack] 100 rounds, 1394 K(B/items) processed in 5 ms
                19050.544 rounds/s, 265.6407821596243 MiB/s

[small_mpack_unpack] 100 rounds, 22 K(B/items) processed in 5 ms
                17875.698 rounds/s, 249.25873973518736 MiB/s

[medium_json_pack] 50 rounds, 13790 K(B/items) processed in 21 ms
                2281.518 rounds/s, 629.2814968250212 MiB/s

[medium_json_unpack] 50 rounds, 110 K(B/items) processed in 50 ms
                981.156 rounds/s, 270.6196202641558 MiB/s

[medium_cbor_pack] 50 rounds, 7064 K(B/items) processed in 25 ms
                1949.574 rounds/s, 275.4630705631718 MiB/s

[medium_cbor_unpack] 50 rounds, 110 K(B/items) processed in 45 ms
                1110.985 rounds/s, 156.97545904678867 MiB/s

[medium_mpack_pack] 50 rounds, 7058 K(B/items) processed in 22 ms
                2228.623 rounds/s, 314.60358360506416 MiB/s

[medium_mpack_unpack] 50 rounds, 110 K(B/items) processed in 45 ms
                1108.577 rounds/s, 156.49220319212682 MiB/s

[large_json_pack] 25 rounds, 69252 K(B/items) processed in 121 ms
                205.906 rounds/s, 570.384210191985 MiB/s

[large_json_unpack] 25 rounds, 550 K(B/items) processed in 375 ms
                66.510 rounds/s, 184.23962102531192 MiB/s

[large_cbor_pack] 25 rounds, 35392 K(B/items) processed in 114 ms
                219.045 rounds/s, 310.0973213175538 MiB/s

[large_cbor_unpack] 25 rounds, 550 K(B/items) processed in 429 ms
                58.268 rounds/s, 82.48883951830622 MiB/s

[large_mpack_pack] 25 rounds, 35388 K(B/items) processed in 112 ms
                221.640 rounds/s, 313.74350800670834 MiB/s

[large_mpack_unpack] 25 rounds, 550 K(B/items) processed in 368 ms
                67.754 rounds/s, 95.90986908660216 MiB/s

[massive_json_pack] 12 rounds, 166745 K(B/items) processed in 269 ms
                44.522 rounds/s, 618.655888089833 MiB/s

[massive_json_unpack] 12 rounds, 1320 K(B/items) processed in 1627 ms
                7.372 rounds/s, 102.43079283973543 MiB/s

[massive_cbor_pack] 12 rounds, 84954 K(B/items) processed in 273 ms
                43.824 rounds/s, 310.2558961071444 MiB/s

[massive_cbor_unpack] 12 rounds, 1320 K(B/items) processed in 2526 ms
                4.749 rounds/s, 33.62090775277059 MiB/s

[massive_mpack_pack] 12 rounds, 84951 K(B/items) processed in 275 ms
                43.538 rounds/s, 308.21693545709616 MiB/s

[massive_mpack_unpack] 12 rounds, 1320 K(B/items) processed in 1856 ms
                6.465 rounds/s, 45.76459028874829 MiB/s
"""


# Function to parse the input string into a list of dictionaries
def parse_benchmarks(data, language):
    """

    [small_json_pack] 100 rounds, 2750 K(B/items) processed in 3.421 ms
                       29235.013 rounds/s, 0.8041090411778042 MiB/s"""

    pattern = r"\[(\w+)_(\w+)\_(\w+)\] (\d+) rounds, (\d+) K\(B/items\) processed in (\d+) ms\s+([\d.]+) rounds/s, ([\d.]+) MiB/s"
    benchmarks = []

    for match in re.findall(pattern, data):
        size, proto, op, rounds, items, time, rounds_per_s, mib_per_s = match
        benchmarks.append(
            {
                "Language": language,
                "Size": size,
                "Proto": proto,
                "op": op,
                "Rounds": int(rounds),
                "items": int(items),
                "Time (ms)": int(time),
                "Rounds/s": float(rounds_per_s),
                "speed": float(mib_per_s),
            }
        )

    return benchmarks


# Parse the benchmarks
benchmarks = parse_benchmarks(data2, "Python3")
benchmarks += parse_benchmarks(data, "Odin")


# Split into unpack and pack tables
unpack_benchmarks = [b for b in benchmarks if "unpack" == b["op"]]
pack_benchmarks = [b for b in benchmarks if "pack" == b["op"]]

# Create DataFrames for unpack and pack
df_unpack = pd.DataFrame(unpack_benchmarks)
del df_unpack["op"]
df_unpack = df_unpack.rename(columns={"items": "K items", "speed": "M items/s"})
df_pack = pd.DataFrame(pack_benchmarks)
del df_pack["op"]
df_pack = df_pack.rename(columns={"items": "KB", "speed": "MiB/s"})


def compute_relative(df):
    def relative_calc(group):
        # Get the value of 'Rounds/s' for the 'cbor' row in the group
        best_value = min(group["Rounds/s"].iloc)
        # Compute relative values for the entire group
        group["Relative"] = (group["Rounds/s"] / best_value * 100).round() / 100
        return group

    # Apply the relative calculation by size
    df = df.groupby("Size").apply(relative_calc)
    df.reset_index(drop=True, inplace=True)
    df = df.sort_values(["Size", "Relative"])

    return df


# Apply relative computation
df_unpack = compute_relative(df_unpack)
df_pack = compute_relative(df_pack)

from matplotlib import pyplot as plt

index_order = ["small", "medium", "large", "massive"]

for name in ["with-mpack.png", "without-mpack.png"]:
    fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(30, 10))
    ax = (
        df_pack.pivot_table(
            index="Size", columns=["Proto", "Language"], values="Relative"
        )
        .loc[index_order]
        .plot.bar(
            ax=axes[0], width=0.8, color=["r", "r", "g", "g", "b", "b"], alpha=0.5
        )
    )
    bars = ax.patches
    hatches = "////....////....////...."

    for bar, hatch in zip(bars, hatches):
        bar.set_hatch(hatch)
    ax.legend()
    ax.set_title("Pack speed, times speedup over worst")

    ax = (
        df_unpack.pivot_table(
            index="Size", columns=["Proto", "Language"], values="Relative"
        )
        .loc[index_order]
        .plot.bar(
            ax=axes[1],
            width=0.8,
            color=["r", "r", "g", "g", "b", "b"],
            alpha=0.5,
            #    hatch=[["/"] * 6] * 4,
        )
    )
    bars = ax.patches
    hatches = "////....////....////...."

    for bar, hatch in zip(bars, hatches):
        bar.set_hatch(hatch)
    ax.legend()
    ax.set_title("Unpack speed, times speedup over worst")
    plt.savefig(name, bbox_inches="tight", dpi=72)

    if name == "with-mpack.png":
        df_unpack = df_unpack.query("Proto != 'mpack'")
        df_pack = df_pack.query("Proto != 'mpack'")

# Display the unpack and pack tables
print("Unpack (Items) Table:")
print(df_unpack.to_markdown(None, index=False))
print("\nPack (MB/s) Table:")
print(df_pack.to_markdown(None, index=False))
