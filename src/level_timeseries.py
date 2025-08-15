import sys
import pandas as pd
import matplotlib.pyplot as plt

def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "data/log_sample.csv"
    df = pd.read_csv(path)
    df["timestamp"] = pd.to_datetime(df["timestamp"])
    df["date"] = df["timestamp"].dt.date

    daily = df.groupby(["date","level"]).size().unstack(fill_value=0)

    plt.figure(figsize=(8,4))
    for col in daily.columns:
        plt.plot(daily.index, daily[col], marker="o", label=col)
    plt.title("Daily Log Count by Level")
    plt.xlabel("Date"); plt.ylabel("Count")
    plt.legend()
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig("output/daily_log_by_level.png")

if __name__ == '__main__':
    main()
