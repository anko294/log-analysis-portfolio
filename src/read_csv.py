import sys
import pandas as pd

def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "data/log_sample.csv"
    df = pd.read_csv(path)
    print(df.head())

if __name__ == '__main__':
    main()
