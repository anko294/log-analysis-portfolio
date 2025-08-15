import sys
import pandas as pd

def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "data/log_sample.csv"
    df = pd.read_csv(path)
    errors = df[df["level"] == "ERROR"].copy()
    errors["timestamp"] = pd.to_datetime(errors["timestamp"])
    errors = errors.sort_values("timestamp")
    print(errors[["timestamp", "message"]])

if __name__ == '__main__':
    main()
