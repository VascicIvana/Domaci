#1. Određivanje doba dana Napisati Python program koji za svaki sat u toku dana (od 0 do 23) ispisuje odgovarajuće doba dana:

# noć (od 22 do 6 časova),
# jutro (od 6 do 12 časova),
# popodne (od 12 do 18 časova) ili
# veče (od 18 do 22 časa).

for hour in range(0, 24):
    print(hour)
    if hour < 6 or hour >= 22:
        print ('noć')
    elif hour >= 6 and hour < 12:
        print('jutro')
    elif hour >= 12 and hour <18:
        print('popodne')
    elif hour >= 18  and hour < 22:
        print ('veče')