﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	////	 //регистр ТоварыНаСкладах Приход
	//Движения.ТоварыНаСкладах.Записывать = Истина; 
	
	//Для Каждого ТекСтрокаОписьТовара Из ОписьТовара Цикл
	//	Движение = Движения.ТоварыНаСкладах.Добавить();
	//	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	//	Движение.Период = Дата;
	//	Движение.Номенклатура = ТекСтрокаОписьТовара.Товар;
	//	Движение.Склад = Склад;
	//	Движение.СрокГодности = ТекСтрокаОписьТовара.СрокГодности;
	//	Движение.Количество = ТекСтрокаОписьТовара.Количество;
	//КонецЦикла;
	//////// 
	Движения.Хозрасчетный.Записывать = Истина;
	СтруктураУчетнаяПолитика = РегистрыСведений.УчетнаяПолитика.ПолучитьПоследнее(Дата).УчетнаяПолитика;
	Если СтруктураУчетнаяПолитика = Перечисления.ВидыУчетнойПолитики.FEFO Тогда
		ОтражатьСрокиГодности = Истина;
	Иначе
		ОтражатьСрокиГодности = Ложь;
	КонецЕсли;
	Движения.ТоварыНаСкладах.Записывать = Истина;	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ПоступлениеТоваровИМатериаловОписьТовара.Товар КАК Номенклатура,
	|	СУММА(ПоступлениеТоваровИМатериаловОписьТовара.Количество) КАК Количество,
	|	СУММА(ПоступлениеТоваровИМатериаловОписьТовара.Сумма) КАК Сумма,
	|	ПоступлениеТоваровИМатериаловОписьТовара.СрокГодности КАК СрокГодности,
	|	ПоступлениеТоваровИМатериаловОписьТовара.Товар.СчетБухгалтерскогоУчета КАК СчетБухгалтерскогоУчета
	|ИЗ
	|	Документ.ПоступлениеТоваровИМатериалов.ОписьТовара КАК ПоступлениеТоваровИМатериаловОписьТовара
	|ГДЕ
	|	ПоступлениеТоваровИМатериаловОписьТовара.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеТоваровИМатериаловОписьТовара.Товар,
	|	ПоступлениеТоваровИМатериаловОписьТовара.СрокГодности";
	
	Выборка = Запрос.Выполнить().Выбрать();  
	Пока Выборка.Следующий() Цикл 
		Движение = Движения.Хозрасчетный.Добавить();
		Движение.СчетДт = Выборка.СчетБухгалтерскогоУчета;
		Движение.СчетКт = ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками;
		Движение.Период = Дата;
		Движение.Сумма = Выборка.Сумма;
		Движение.Содержание = "Отражено поступление товарно-материальных ценностей от поставщика";
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура] = Выборка.Номенклатура;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты] = Поставщик;
		
		Движение = Движения.ТоварыНаСкладах.Добавить(); 
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Склад = Склад;
		Движение.Количество = Выборка.Количество;
		Движение.Сумма = Выборка.Сумма;
		Если ОтражатьСрокиГодности Тогда 
			Движение.СрокГодности = Выборка.СрокГодности;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	СуммаДокумента = ОписьТовара.Итог("Сумма");
КонецПроцедуры
