import sys
import pandas as pd
import matplotlib.pyplot as plt

def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "data/log_sample.csv"
    df = pd.read_csv(path)
    df["timestamp"] = pd.to_datetime(df["timestamp"])
    df["date"] = df["timestamp"].dt.date
    daily = df[df["level"]=="ERROR"].groupby("date").size()

    plt.figure(figsize=(8,4))
    daily.plot(kind="line", marker="o")
    plt.title("Daily ERROR Log Count")
    plt.xlabel("Date"); plt.ylabel("Count")
    plt.tight_layout()
    plt.savefig("output/error_log_daily.png")

if __name__ == '__main__':
    main()
