#!/usr/bin/env python3
"""
Test FMP API Integration
"""

import os
import json
import pandas as pd
import requests
from datetime import datetime

# Set your FMP API key here for testing
FMP_API_KEY = os.getenv('FMP_API_KEY', '')

def test_fmp_single_stock():
    """Test fetching a single stock from FMP"""
    print("🧪 Testing FMP API - Single Stock")
    print("=" * 50)
    
    if not FMP_API_KEY:
        print("❌ FMP_API_KEY not set")
        print("Please set it: export FMP_API_KEY='your_key_here'")
        return False
    
    # Test with 9988.HK (Alibaba)
    symbol = "9988.HK"
    url = f"https://financialmodelingprep.com/api/v3/historical-price-full/{symbol}?from=2024-01-01&to=2024-12-31&apikey={FMP_API_KEY}"
    
    print(f"📡 Fetching {symbol}...")
    print(f"URL: {url[:80]}...")
    
    try:
        response = requests.get(url, timeout=30)
        print(f"Status: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            
            if 'historical' in data:
                historical = data['historical']
                print(f"✅ Success! Got {len(historical)} data points")
                
                # Show first few entries
                print("\n📊 Sample data:")
                for entry in historical[:5]:
                    print(f"  {entry['date']}: Close=${entry['close']:.2f}")
                
                return True
            else:
                print(f"❌ No 'historical' key in response")
                print(f"Response: {data}")
                return False
        else:
            print(f"❌ HTTP Error: {response.status_code}")
            print(f"Response: {response.text[:200]}")
            return False
            
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_cache_system():
    """Test the caching system"""
    print("\n🧪 Testing Cache System")
    print("=" * 50)
    
    # Create test cache
    test_cache = {
        'dates': ['2024-01-01', '2024-01-02', '2024-01-03'],
        'stocks': {
            '9988': {
                '2024-01-01': 100.0,
                '2024-01-02': 101.5,
                '2024-01-03': 99.8
            },
            '0388': {
                '2024-01-01': 400.0,
                '2024-01-02': 405.2,
                '2024-01-03': 398.5
            }
        }
    }
    
    # Save cache
    cache_file = 'test_cache.json'
    try:
        with open(cache_file, 'w') as f:
            json.dump(test_cache, f, indent=2)
        print(f"✅ Created test cache: {cache_file}")
        
        # Load cache
        with open(cache_file, 'r') as f:
            loaded = json.load(f)
        
        print(f"✅ Loaded cache with {len(loaded['dates'])} dates")
        print(f"   Stocks: {list(loaded['stocks'].keys())}")
        
        # Convert to DataFrame
        all_prices = {}
        for stock_code, stock_data in loaded['stocks'].items():
            dates = pd.to_datetime(list(stock_data.keys()))
            prices = [stock_data[d] for d in stock_data.keys()]
            all_prices[stock_code] = pd.Series(prices, index=dates)
        
        df = pd.DataFrame(all_prices)
        print(f"\n📊 DataFrame:")
        print(df)
        
        # Clean up
        os.remove(cache_file)
        print(f"\n✅ Cache system working!")
        return True
        
    except Exception as e:
        print(f"❌ Cache test failed: {e}")
        if os.path.exists(cache_file):
            os.remove(cache_file)
        return False

def test_full_workflow():
    """Test the full workflow with FMP API"""
    print("\n🧪 Testing Full Workflow")
    print("=" * 50)
    
    if not FMP_API_KEY:
        print("⚠️ Skipping (no API key)")
        return False
    
    # Import the functions from main script
    import sys
    sys.path.insert(0, '.')
    
    try:
        from hk_stock_analysis_docker import (
            load_stock_prices_with_fmp_cache,
            load_cache,
            save_cache
        )
        
        print("📥 Testing with real FMP API...")
        
        # Test with just one stock for speed
        stock_codes = ['9988']
        
        # First run - should fetch from API
        print("\n1️⃣ First run (should fetch from API):")
        df1 = load_stock_prices_with_fmp_cache(stock_codes, start_date='2024-01-01')
        
        if not df1.empty:
            print(f"✅ Got {len(df1)} rows")
            print(df1.tail(3))
            
            # Second run - should use cache
            print("\n2️⃣ Second run (should use cache):")
            df2 = load_stock_prices_with_fmp_cache(stock_codes, start_date='2024-01-01')
            
            if not df2.empty:
                print(f"✅ Got {len(df2)} rows from cache")
                print(df2.tail(3))
                
                # Clean up
                if os.path.exists('stock_prices_cache.json'):
                    os.remove('stock_prices_cache.json')
                    print("\n🧹 Cleaned up cache file")
                
                return True
        
        return False
        
    except Exception as e:
        print(f"❌ Workflow test failed: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    print("🔑 FMP API Key:", "SET" if FMP_API_KEY else "NOT SET")
    print()
    
    # Run tests
    test1 = test_fmp_single_stock()
    test2 = test_cache_system()
    test3 = test_full_workflow()
    
    print("\n" + "=" * 50)
    print("📊 Test Results:")
    print(f"  FMP API:        {'✅ PASS' if test1 else '❌ FAIL'}")
    print(f"  Cache System:   {'✅ PASS' if test2 else '❌ FAIL'}")
    print(f"  Full Workflow:  {'✅ PASS' if test3 else '❌ FAIL'}")
    
    if test1 and test2:
        print("\n🎉 Ready to use FMP API!")
        print("\n📝 Next steps:")
        print("1. Set your FMP_API_KEY environment variable")
        print("2. Build Docker: docker build -t gary-stock-analysis .")
        print("3. Run Docker: docker run --rm -e FMP_API_KEY='your_key' gary-stock-analysis")
    else:
        print("\n⚠️ Some tests failed - please check configuration")

