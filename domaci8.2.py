# Zadatak 16
# Napisati funkciju count_lines(path: str) -> int koja prima putanju do fajla
# i vraća broj nepraznih linija u tom fajlu.
#
# Ulaz: data/raw/teams.csv
# Očekivani izlaz: 5

def count_lines(path: str):
    count = 0
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            if line.strip():
                count += 1

    return count
print(count_lines(path))


# Zadatak 17
# Napisati funkciju read_column(path: str, column: str) -> list
# koja prima putanju do CSV fajla i naziv kolone,
# a vraća listu svih vrednosti iz te kolone.
#
# Ako kolona ne postoji, funkcija treba da vrati praznu listu.
#
# Ulaz: path, "city"
# Očekivani izlaz:
# ['Bela Palanka', 'Niš', 'Beograd, Rakovica', 'Kraljevo']

def read_column(path, column):
    values = []
    with open(path, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        if column not in reader.fieldnames:
            return []
        for row in reader:
            values.append(row[column])
    return values

print(read_column(path, "city"))



# Zadatak 19
# Napisati funkciju get_header(path) koja vraća zaglavlje CSV fajla.
# Obavezno koristiti csv.reader i next().
# Očekivani izlaz: ['team', 'city', 'points']

def get_header(path):
    with open(path, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        header = next(reader)
        return header
print(get_header(path))


# Zadatak 20
# Napisati funkciju read_rows(path) koja vraća sve redove iz CSV fajla,
# bez zaglavlja, kao listu listi.
# Obavezno koristiti csv.reader.
# Očekivani izlaz:
# [['FK Jedinstvo', 'Bela Palanka', '34'],
#  ['FK Radnički', 'Niš', '41'],
#  ['FK Rakovica', 'Beograd, Rakovica', '28'],
#  ['FK Sloga', 'Kraljevo', '19']]


def read_rows(path):
    rows = []
    with open(path, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        next(reader)
        for row in reader:
            rows.append(row)
    return rows
print(read_rows(path))


# Zadatak 21
# Napisati funkciju total_points(path) koja sabira bodove svih timova.
# Obavezno koristiti csv.DictReader.
# Očekivani izlaz: 122

def total_points(path):
    total = 0
    with open(path, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            total += int(row["points"])
    return total
print(total_points(path))


# Zadatak 22
# Napisati funkciju write_rows(path, rows) koja upisuje listu listi u CSV fajl.
# Ulaz: path = "data/processed/people.csv"
# rows = [["name", "age"], ["Ana", 20], ["Marko", 22]]
# Očekivani sadržaj fajla:
# name,age
# Ana,20
# Marko,22

def write_rows(path, rows):
    with open(path, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerows(rows)


# Zadatak 23
# Napisati funkciju write_dicts(path, rows) koja upisuje listu rečnika u CSV fajl.
# Obavezno koristiti csv.DictWriter.
# Zaglavlja se uzimaju iz ključeva prvog rečnika.
# Ulaz: rows = [{"name": "Ana", "age": 20}, {"name": "Marko", "age": 22}]
# Očekivani sadržaj fajla:
# name,age
# Ana,20
# Marko,22
def write_dicts(path, rows):
    with open(path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)