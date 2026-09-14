import re

import pandas as pd
from matplotlib import pyplot as plt

# Sample input data string
data = """
[small_mpack_unpack] 100 rounds, 22 K(B/items) processed in 3 ms
                25162.696 rounds/s, 5.279 MiB/s

[medium_mpack_unpack] 100 rounds, 220 K(B/items) processed in 38 ms
                2604.318 rounds/s, 5.464 MiB/s

[large_mpack_unpack] 100 rounds, 2200 K(B/items) processed in 403 ms
                247.999 rounds/s, 5.203 MiB/s

[massive_mpack_unpack] 100 rounds, 11000 K(B/items) processed in 2053 ms
                48.697 rounds/s, 5.109 MiB/s

[small_cbor_unpack] 100 rounds, 22 K(B/items) processed in 7 ms
                12818.539 rounds/s, 2.689 MiB/s

[medium_cbor_unpack] 100 rounds, 220 K(B/items) processed in 66 ms
                1502.825 rounds/s, 3.153 MiB/s

[large_cbor_unpack] 100 rounds, 2200 K(B/items) processed in 646 ms
                154.691 rounds/s, 3.246 MiB/s

[massive_cbor_unpack] 100 rounds, 11000 K(B/items) processed in 3073 ms
                32.534 rounds/s, 3.413 MiB/s

[small_json_unpack] 100 rounds, 22 K(B/items) processed in 49 ms
                2021.838 rounds/s, 0.424 MiB/s

[medium_json_unpack] 100 rounds, 220 K(B/items) processed in 527 ms
                189.439 rounds/s, 0.397 MiB/s

[large_json_unpack] 100 rounds, 2200 K(B/items) processed in 5133 ms
                19.481 rounds/s, 0.409 MiB/s

[massive_json_unpack] 100 rounds, 11000 K(B/items) processed in 25709 ms
                3.890 rounds/s, 0.408 MiB/s

[small_cbor_pack] 100 rounds, 922 K(B/items) processed in 5 ms
                18732.555 rounds/s, 164.838 MiB/s

[medium_cbor_pack] 100 rounds, 9329 K(B/items) processed in 44 ms
                2222.833 rounds/s, 197.774 MiB/s

[large_cbor_pack] 100 rounds, 93533 K(B/items) processed in 519 ms
                192.410 rounds/s, 171.631 MiB/s

[massive_cbor_pack] 100 rounds, 467796 K(B/items) processed in 2446 ms
                40.872 rounds/s, 182.340 MiB/s

[small_json_pack] 100 rounds, 1817 K(B/items) processed in 19 ms
                5024.478 rounds/s, 87.099 MiB/s

[medium_json_pack] 100 rounds, 18274 K(B/items) processed in 200 ms
                499.625 rounds/s, 87.075 MiB/s

[large_json_pack] 100 rounds, 183846 K(B/items) processed in 2045 ms
                48.879 rounds/s, 85.700 MiB/s

[massive_json_pack] 100 rounds, 923926 K(B/items) processed in 10203 ms
                9.801 rounds/s, 86.358 MiB/s

[small_mpack_pack] 100 rounds, 914 K(B/items) processed in 1 ms
                70436.126 rounds/s, 614.231 MiB/s

[medium_mpack_pack] 100 rounds, 9316 K(B/items) processed in 15 ms
                6619.427 rounds/s, 588.130 MiB/s

[large_mpack_pack] 100 rounds, 93549 K(B/items) processed in 139 ms
                719.254 rounds/s, 641.684 MiB/s

[massive_mpack_pack] 100 rounds, 467931 K(B/items) processed in 734 ms
                136.090 rounds/s, 607.309 MiB/s
"""

data2 = """
[small_cbor_pack] 100 rounds, 922 K(B/items) processed in 4 ms
                20981.630 rounds/s, 184.549 MiB/s

[medium_cbor_pack] 100 rounds, 9325 K(B/items) processed in 47 ms
                2094.987 rounds/s, 186.315 MiB/s

[large_cbor_pack] 100 rounds, 93537 K(B/items) processed in 472 ms
                211.544 rounds/s, 188.706 MiB/s

[massive_cbor_pack] 100 rounds, 467790 K(B/items) processed in 2442 ms
                40.939 rounds/s, 182.636 MiB/s

[small_json_pack] 100 rounds, 1817 K(B/items) processed in 18 ms
                5292.751 rounds/s, 91.744 MiB/s

[medium_json_pack] 100 rounds, 18265 K(B/items) processed in 193 ms
                517.919 rounds/s, 90.219 MiB/s

[large_json_pack] 100 rounds, 183864 K(B/items) processed in 2011 ms
                49.726 rounds/s, 87.193 MiB/s

[massive_json_pack] 100 rounds, 923990 K(B/items) processed in 10231 ms
                9.774 rounds/s, 86.127 MiB/s

[small_mpack_pack] 100 rounds, 914 K(B/items) processed in 1 ms
                71304.603 rounds/s, 621.805 MiB/s

[medium_mpack_pack] 100 rounds, 9320 K(B/items) processed in 14 ms
                7013.786 rounds/s, 623.409 MiB/s

[large_mpack_pack] 100 rounds, 93554 K(B/items) processed in 142 ms
                700.583 rounds/s, 625.065 MiB/s

[massive_mpack_pack] 100 rounds, 467933 K(B/items) processed in 733 ms
                136.423 rounds/s, 608.796 MiB/s

[small_mpack_unpack] 100 rounds, 22 K(B/items) processed in 3 ms
                27696.074 rounds/s, 5.811 MiB/s

[medium_mpack_unpack] 100 rounds, 220 K(B/items) processed in 33 ms
                2955.008 rounds/s, 6.200 MiB/s

[large_mpack_unpack] 100 rounds, 2200 K(B/items) processed in 397 ms
                251.446 rounds/s, 5.276 MiB/s

[massive_mpack_unpack] 100 rounds, 11000 K(B/items) processed in 2036 ms
                49.114 rounds/s, 5.152 MiB/s

[small_cbor_unpack] 100 rounds, 22 K(B/items) processed in 6 ms
                15974.497 rounds/s, 3.352 MiB/s

[medium_cbor_unpack] 100 rounds, 220 K(B/items) processed in 74 ms
                1338.230 rounds/s, 2.808 MiB/s

[large_cbor_unpack] 100 rounds, 2200 K(B/items) processed in 676 ms
                147.904 rounds/s, 3.103 MiB/s

[massive_cbor_unpack] 100 rounds, 11000 K(B/items) processed in 3185 ms
                31.394 rounds/s, 3.293 MiB/s

[small_json_unpack] 100 rounds, 22 K(B/items) processed in 52 ms
                1899.418 rounds/s, 0.399 MiB/s

[medium_json_unpack] 100 rounds, 220 K(B/items) processed in 504 ms
                198.283 rounds/s, 0.416 MiB/s

[large_json_unpack] 100 rounds, 2200 K(B/items) processed in 5126 ms
                19.506 rounds/s, 0.409 MiB/s

[massive_json_unpack] 100 rounds, 11000 K(B/items) processed in 24454 ms
                4.089 rounds/s, 0.429 MiB/s"""


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
                "Delta": language,
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
benchmarks = parse_benchmarks(data, "Before")
benchmarks += parse_benchmarks(data2, "After")

unpack_benchmarks = [b for b in benchmarks if "unpack" == b["op"]]
df_unpack = pd.DataFrame(unpack_benchmarks)
del df_unpack["op"]
df_unpack = df_unpack.rename(columns={"items": "K items", "speed": "M items/s"})
df_unpack = df_unpack.query("Proto == 'mpack'")
df_unpack = compute_relative(df_unpack)

pack_benchmarks = [b for b in benchmarks if "pack" == b["op"]]
df_pack = pd.DataFrame(pack_benchmarks)
del df_pack["op"]
df_pack = df_pack.rename(columns={"items": "KB", "speed": "MiB/s"})
df_pack = df_pack.query("Proto == 'mpack'")
df_pack = compute_relative(df_pack)

# Apply relative computation

index_order = ["small", "medium", "large", "massive"]

for name in ["with-mpack.png", "without-mpack.png"]:
    fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(20, 5))
    ax = (
        df_pack.pivot_table(index="Size", columns=["Delta"], values="Relative")
        .loc[index_order]
        .plot.bar(ax=axes[0], width=0.8, color=["r", "g"], alpha=0.5)
    )

    ax.legend()
    ax.set_title("Pack speed, relative change")

    ax = (
        df_unpack.pivot_table(index="Size", columns=["Delta"], values="Relative")
        .loc[index_order]
        .plot.bar(
            ax=axes[1],
            width=0.8,
            color=["r", "g"],
            alpha=0.5,
            #    hatch=[["/"] * 6] * 4,
        )
    )

    ax.legend()
    ax.set_ylim(0.0, 1.5)
    ax.set_title("Unpack speed, relative change")

    plt.savefig(name, bbox_inches="tight", dpi=144)

    # if name == "with-mpack.png":
    #     df_unpack = df_unpack.query("Proto != 'mpack'")
    #     df_pack = df_pack.query("Proto != 'mpack'")
df_unpack = df_unpack.query("Proto == 'mpack'")
# Display the unpack and pack tables
print("Unpack (Items) Table:")
print(df_unpack.to_markdown(None, index=False))
print("\nPack (MB/s) Table:")
print(df_pack.to_markdown(None, index=False))
