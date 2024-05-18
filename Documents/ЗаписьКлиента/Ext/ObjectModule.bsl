﻿ 
 Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	 Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		 Ответственный = ПараметрыСеанса.ТекущийПользователь;
	 КонецЕсли;
	 Если ЗначениеЗаполнено(Ссылка) И УслугаОказана = Ложь Тогда
		 ПроверитьОказаниеУслуг();
	 КонецЕсли;
	 ДлительностьУслуг = РассчитатьДатуОкончанияЗаписи();
	 Если ДлительностьУслуг = 0 Тогда // 1
		 ДлительностьУслуг = 60;
	 КонецЕсли;
	 ДатаОкончанияЗаписи = ДатаЗаписи + ДлительностьУслуг*60;
 КонецПроцедуры   
 
 Процедура ОбработкаПроведения(Отказ, Режим)
	 // регистр ЗаказыКлиентов. МОЙ КОД, который работал!!!
	 //Движения.ЗаказыКлиентов.Записывать = Истина;
	 //Движение = Движения.ЗаказыКлиентов.Добавить();
	 //Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	 //Движение.Период = Дата;
	 //Движение.Клиент = Клиент;
	 //Движение.ЗаписьКлиента = Ссылка;
	 //Движение.Сумма = ОписаниеУслуг.Итог("Стоимость");
	 ////////////////////////////////////// 
	 
	 /// Код скопирован из теории:
	 Движения.ЗаказыКлиентов.Записывать = Истина;
	 Для Каждого ТекСтрокаОписаниеУслуг Из ОписаниеУслуг Цикл
		 Движение = Движения.ЗаказыКлиентов.Добавить();
		 Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		 Движение.Период = Дата;
		 Движение.Клиент = Клиент;
		 Движение.ЗаписьКлиента = Ссылка;
		 Движение.Сумма = ТекСтрокаОписаниеУслуг.Сумма;
		 Движение.ДатаЗаписи = ДатаЗаписи;
	 КонецЦикла;
 КонецПроцедуры
 
 Процедура ПроверитьОказаниеУслуг()
	 
	 Запрос = Новый Запрос;
	 Запрос.УстановитьПараметр("Основание",Ссылка);
	 
	 Запрос.Текст = "ВЫБРАТЬ
	 |    РеализацияТоваровИУслуг.Ссылка КАК Ссылка
	 |ИЗ
	 |    Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
	 |ГДЕ
	 |    РеализацияТоваровИУслуг.Основание = &Основание
	 |    И РеализацияТоваровИУслуг.Проведен
	 |
	 |СГРУППИРОВАТЬ ПО
	 |    РеализацияТоваровИУслуг.Ссылка";
	 
	 Рез = Запрос.Выполнить();
	 Если НЕ Рез.Пустой() Тогда
		 УслугаОказана = Истина;
	 КонецЕсли;
	 
 КонецПроцедуры 
 
 Функция РассчитатьДатуОкончанияЗаписи()
	 
	 ТЧУслуги = ОписаниеУслуг.Выгрузить(,"Услуга"); //1
	 
	 Запрос = Новый Запрос;
	 Запрос.УстановитьПараметр("ТЧУслуги", ТЧУслуги); //2
	 Запрос.Текст=
	 "ВЫБРАТЬ
	 |    ТЧУслуги.Услуга КАК Номенклатура
	 |ПОМЕСТИТЬ ВТ_Номенклатура
	 |ИЗ
	 |    &ТЧУслуги КАК ТЧУслуги
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |    СУММА(Ном.ДлительностьУслуги) КАК ДлительностьУслуги
	 |ИЗ
	 |    ВТ_Номенклатура КАК ВТ_Номенклатура
	 |        ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Ном
	 |        ПО ВТ_Номенклатура.Номенклатура = Ном.Ссылка";
	 
	 Рез = Запрос.Выполнить();
	 Если Рез.Пустой() Тогда
		 возврат 0;
	 КонецЕсли;
	 
	 Выборка = Запрос.Выполнить().Выбрать();
	 Выборка.Следующий();
	 возврат Выборка.ДлительностьУслуги;
	 
 КонецФункции
