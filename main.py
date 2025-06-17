# main.py
import json
# 1. Customers: {id: name}
customers = {
    1: 'Amina Okafor',
    2: "Daniel O'Neill",
    3: 'Chioma Nwosu',
    4: 'Mateo Alvarez',
    5: 'Olivia Smith',
    6: 'Tariq Al-Mansour'
}

# 2. Products: {id: {'name':…, 'price':…}}
products = {
    1: {'name': 'Smartphone', 'price': 699.99},
    2: {'name': 'Tablet',     'price': 329.50},
    3: {'name': 'Laptop',     'price': 1199.00},
    4: {'name': 'Smartwatch', 'price': 199.99},
    5: {'name': 'Headphones', 'price': 149.95}
}

# 3. New orders: a list of dicts, each with items [(product_id, qty),…]
new_orders = [
    {'order_id': 101, 'cust_id': 1, 'items': [(1, 1), (5, 2)]},
    {'order_id': 102, 'cust_id': 2, 'items': [(2, 1)]},
    {'order_id': 103, 'cust_id': 3, 'items': [(3, 1), (4, 1)]},
    {'order_id': 104, 'cust_id': 4, 'items': [(5, 3)]},
    {'order_id': 105, 'cust_id': 5, 'items': [(1, 2)]},
    {'order_id': 106, 'cust_id': 6, 'items': [(4, 1)]}
]


# 4. Identify & print orders totaling over $100
print("Large orders (> $100):")
for order in new_orders:
    total = sum(products[pid]['price'] * qty for pid, qty in order['items'])
    if total > 100:
        name = customers[order['cust_id']]
        print(f"  • Order {order['order_id']} by {name}: ${total:.2f}")

# 5. Convert GBP→USD & discount high-value items
exchange_rate = 1.3   # example: £1 → $1.30
for pid, info in products.items():
    usd = info['price'] * exchange_rate
    if usd > 500:
        usd *= 0.9     # 10% discount
    products[pid]['price_usd'] = round(usd, 2)

# Optional: print to check
# print({pid: p['price_usd'] for pid, p in products.items()})

# 6. Initialize report structure
report = {
    'total_products_sold': 0,
    'product_counts': {},         # pid → total qty
    'revenue_per_customer': {}    # name → total USD revenue
}

# 7. Populate report
for order in new_orders:
    cust = customers[order['cust_id']]
    report['revenue_per_customer'].setdefault(cust, 0)
    for pid, qty in order['items']:
        report['total_products_sold'] += qty
        report['product_counts'][pid] = report['product_counts'].get(pid, 0) + qty
        report['revenue_per_customer'][cust] += products[pid]['price_usd'] * qty

# 8. Find most popular product
most_pop = max(report['product_counts'], key=report['product_counts'].get)
report['most_popular_product'] = products[most_pop]['name']

# 9. Nicely formatted output
print("\n📊 Summary Report")
print("Total products sold:", report['total_products_sold'])
print("Most popular product:", report['most_popular_product'])
print("Revenue per customer:")
for cust, rev in report['revenue_per_customer'].items():
    print(f"  - {cust}: ${rev:.2f}")

# 10. Save report to JSON
with open('report.json', 'w') as f:
    json.dump(report, f, indent=2)
print("\nReport written to report.json")

