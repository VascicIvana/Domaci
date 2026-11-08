# 1. Napisati funkciju get_even_positions(data: tuple) -> tuple koja
# vraća elemente torke koji se nalaze na parnim indeksima (0, 2, 4...).
# Input: (10, 20, 30, 40, 50, 60)
# Output: (10, 30, 50)


def get_even_positions(data: tuple):
    return data[0:5:2]
print(get_even_positions((10, 20, 30, 40, 50, 60)))


# 2. Napisati funkciju find_exclusive_students(group1: set, group2: set) -> set koja vraca studente koji se nalaze u prvoj grupi, ali ne i u drugoj.
# Input: {'Ana', 'Marko', 'Jovan', 'Milica'}, {'Marko', 'Milica', 'Petar'}
# Output: {'Ana', 'Jovan'}


def find_exclusive_students(group1: set, group2: set):
    return group1 - group2
print(find_exclusive_students({'Ana', 'Marko', 'Jovan', 'Milica'}, {'Marko', 'Milica', 'Petar'}))


# 3. Napisati funkciju clean_tags(text: str) -> str koja obradjuje tekst sa tagovima.
# Potrebno je:
# - Razdvojiti tagove koji su odvojeni karakterom |
# - Ukloniti pocetne i krajnje razmake svakog taga
# - Sva slova pretvoriti u mala slova
# - Spojiti tagove karakterom -
# Input: ' Python | DATA | SQL '
# Output: 'python-data-sql'

def clean_tags(text: str):
     tags = text.split('|')
     result = []
     for tag in tags:
        result.append(tag.strip().lower())
     return '-'.join(result)

print(clean_tags(' Python | DATA | SQL '))


# 4. Napisati funkciju count_products(csv_lines: list) -> dict koja analizira porudzbine iz CSV podataka i vraca ukupan broj narucenih proizvoda.
# Svaki red sadrzi ime kupca, naziv proizvoda i kolicinu, razdvojene zarezom.
# Prvi red predstavlja zaglavlje i treba ga zanemariti.
# Ako se isti proizvod pojavljuje u vise redova, sabrati njegove kolicine.
# Input:
# [
#     'customer,product,quantity',
#     'Alice,laptop,2',
#     'Bob,mouse,3',
#     'Alice,laptop,1',
#     'Charlie,keyboard,2',
#     'Bob,mouse,1'
# ]
# Output:
# {
#     'laptop': 3,
#     'mouse': 4,
#     'keyboard': 2
# }

def count_products(csv_lines: list):
    
    result = {}

    for line in csv_lines[1:]:
        customer, product, quantity = line.split(',')
        quantity = int(quantity)
        if product in result:
            result[product] += quantity
        else:
            result[product] = quantity
    return result


print(count_products([
    'customer,product,quantity',
    'Alice,laptop,2',
    'Bob,mouse,3',
    'Alice,laptop,1',
    'Charlie,keyboard,2',
    'Bob,mouse,1'
]))