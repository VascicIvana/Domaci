# 0.1. Napisati program kojim se prevodi temperatura iz Celzijusove skale u Farenhajtovu skalu,
# ako je odgovaraju´ca formula oblika T [◦F] = T [◦C] · 1.80 + 32. Na ulazu se unosi vrednost
# temperature u stepenima Celzijusa (realan broj) a ispisuje se vrednost temperature u stepenima
# Farenhajta


C= float(input('unesti temp u celzijusima'))
F = C * 1.8 +32
print(F)


# 0.2. Napisati program koji za uneti redni broj dana u nedelji (od 1 do 7) ispisuje naziv tog
# dana (ponedeljak - nedelja). Ukoliko je unet broj koji nije izmed¯u 1 i 7, ispisati Pogresan
# unos.

C = int(input('unesi redni broj dana u nedelji'))
if C == 1:
    print('ponedeljak')
elif C==2:
    print('utorak')
elif C==3:
    print('sreda')
elif C==4:
    print('cetvrtak')
elif C==5:
    print('petak')
elif C==6:
    print('subota')
elif C==7:
    print('nedelja')
else:
    print('pogresan unos')


#0.3. Napisati program koji raˇcuna najve´ci negativni element u listi.

numbers = [-8, 5, -2, -15, 3, -4]
max_negative = None
for number in numbers:
    if number < 0:
        if max_negative is None:
            max_negative = number
        elif number > max_negative:
            max_negative = number
print(max_negative)



#0.5. Napisati program koji raˇcuna broj parnih elemenata date liste.

numbers = [4, 7, 2, 9, 12, 5, 8, 10, 18]
even_count = 0
for number in numbers:
    if number % 2 == 0:
        even_count = even_count +1
print(even_count)


# 0.6. Napisati program koji raˇcuna sume elemenata liste celih brojeva koji su deljivi sa 2 odnosno sa 3.

numbers = [4, 7, 2, 9, 12, 5, 8, 10, 18]
sum_div_2 = 0
sum_div_3 = 0

for number in numbers:
    if number % 2 == 0:
        sum_div_2 = sum_div_2 + number
    if number % 3 == 0:
        sum_div_3 = sum_div_3 + number

print(sum_div_2)
print(sum_div_3)


