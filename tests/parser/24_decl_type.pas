{ Объявление типов: диапазоны чисел и символов, отрицательная граница, перечисление }

program DeclType;
type
  TSmall = 1..10;
  TLetter = 'a'..'z';
  TSigned = -5..5;
  TColor = (red, green, blue);
begin end.