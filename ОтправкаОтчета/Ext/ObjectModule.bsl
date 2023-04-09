﻿Функция СведенияОВнешнейОбработке() Экспорт
	
	РегистрационныеДанные = Новый Структура;
	РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
	РегистрационныеДанные.Вставить("Вид","ДополнительнаяОбработка");
	РегистрационныеДанные.Вставить("Наименование", "Отправка Отчета");
	РегистрационныеДанные.Вставить("Версия", "1.0.1");
	
	РегистрационныеДанные.Вставить("Информация", "Шатаем сохранение отчета бля");
	
	ТЗКоманд = Новый ТаблицаЗначений;
	ТЗКоманд.Колонки.Добавить("Наименование");
	ТЗКоманд.Колонки.Добавить("Представление");
	ТЗКоманд.Колонки.Добавить("Идентификатор");
	ТЗКоманд.Колонки.Добавить("Использование");
	ТЗКоманд.Колонки.Добавить("ПоказыватьОповещение");
	ТЗКоманд.Колонки.Добавить("СписокПараметров");

	СтрокаКоманды = тзКоманд.Добавить();
	СтрокаКоманды.Идентификатор = "ОтправкаОтчета";
	СтрокаКоманды.Наименование = "Отправка Отчета"; 
	СтрокаКоманды.Представление = "Отправка Отчета";
	СтрокаКоманды.ПоказыватьОповещение 	= Истина;
	СтрокаКоманды.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	//СтрокаКоманды.СписокПараметров = СписокПараметров;
	
	РегистрационныеДанные.Вставить("Команды", ТЗКоманд);
	
	Возврат РегистрационныеДанные;
	
КонецФункции

Процедура ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыОбработки = Неопределено) Экспорт
	
	
	Если ИдентификаторКоманды = "ОтправкаОтчета" Тогда 
		
		/////////////////////////////////////
		//Выполниь Обработчик отправки Отчета
		Отчет();
		
	КонецЕсли;
	
КонецПроцедуры   

Процедура Отчет() Экспорт
	ТекстПисьма = "Ваааууууу";
	ТабДок = СоздатьОтчет();
	
	ПутьКФайлу = "D:\Почта\";
	ИмяФайла = "ОтчетПоМагазинам.pdf";
	ПолноеИмяФайла = ПутьКФайлу + ИмяФайла;
	
	
	
	ВыгрузитьТДвФайл(ТабДок, ПолноеИмяФайла, ТекстПисьма);
	
		////ОтправитьПочту();
	
КонецПроцедуры

Функция СоздатьОтчет() Экспорт	
  НачалоПериода =  НачалоДня(ТекущаяДата()) - 60 * 60 * 24 * 28;
	КонецПериода = КонецДня(ТекущаяДата()- 60 * 60 * 24);
	ТекДата = ТекущаяДатаСеанса();
	ТабДок = Новый ТабличныйДокумент;
	
	СхемаКомпоновкиДанных = Отчеты.ВедомостьПоТоварамНаСкладах.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	//Ключ = "Ведомость по товарам на складах";
	Пользователь = Справочники.Пользователи.НайтиПоНаименованию("Макашкина Елена");
	ВариантыОтчета = ВариантыОтчетов.КлючиВариантовОтчета("Отчет.ВедомостьПоТоварамНаСкладах", Пользователь);	
  ВариантОтчетаМетаданных = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоНаименованию("Ведомость по товарам на складах (Отчет)");
	КлючВарианта = Неопределено;
	
	Для каждого ВариантОтчета Из ВариантыОтчета Цикл
		Если ВариантОтчета.Представление = "ОСТАТКИ товары в магазинах" Тогда
			 КлючВарианта = ВариантОтчета.Значение;   
			 Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ВариантОтчета = ВариантыОтчетов.ВариантОтчета(ВариантОтчетаМетаданных, КлючВарианта);
	
	//Стыврит настройки пользователя
	//Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	Настройки =  ВариантОтчета.Настройки.Получить();
	ПараметрыВывода = Настройки.ПараметрыВывода.Элементы;
	ПараметрыВывода.Найти("ВыводитьПараметрыДанных").Значение = Ложь;
	Период = Настройки.ПараметрыДанных.Элементы.Найти("Период");
	Период.Значение.ДатаНачала = НачалоПериода;
	Период.Значение.ДатаОкончания = КонецПериода;  
	
	Настройки.Структура[0].Структура[0].Структура[0].Использование = Истина;
	
	
	Расшифровка = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, Расшифровка);
	МакетКомпоновки.ЗначенияПараметров.ТекущаяДата.Значение = ТекДата;
	
	ВнешниеПараметры = Новый Структура;
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ,Расшифровка);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабДок);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
	Возврат ТабДок;
КонецФункции

Функция НайтиОтчетПоНаименованию(Наименование)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВариантыОтчетов.Отчет КАК Отчет
		|ИЗ
		|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
		|ГДЕ
		|	ВариантыОтчетов.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Отчет;
	Иначе 
		Справочники.ВариантыОтчетов.ПустаяСсылка();
	КонецЕсли;
КонецФункции 

Процедура ВыгрузитьТДвФайл(ТабДок, ПолноеИмяФайла, ТекстПисьма) Экспорт
	Попытка
		ТабДок.Записать(ПолноеИмяФайла,ТипФайлаТабличногоДокумента.PDF);	
	Исключение
		ТекстПисьма = ТекстПисьма + "Не удалось создать файл! " + ОписаниеОшибки() + Символы.ПС;
	КонецПопытки;   
	
	МоиРегламентыеЗадания.ОтправитьСообщениеТелеграмм(ТекстПисьма);

КонецПроцедуры


Процедура ОтправитьПочту()

	

КонецПроцедуры

