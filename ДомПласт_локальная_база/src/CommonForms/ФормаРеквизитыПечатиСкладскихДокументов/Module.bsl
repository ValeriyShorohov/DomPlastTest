
&НаКлиенте
Процедура ОК(Команда)
	
		
	ПеренестиВДокумент = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивЭлементов = Новый Массив();
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,,"ЗакрыватьПриВыборе,ЗакрыватьПриЗакрытииВладельца,ИнвентаризационнаяКомиссия");
	
	Для Каждого Элемент Из Параметры.ИнвентаризационнаяКомиссия Цикл
		НоваяСтрока = ЭтаФорма.ИнвентаризационнаяКомиссия.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Элемент);
	КонецЦикла;
	
	СтруктураПараметров = ИзменяемыеРеквизиты(Параметры);
	
	МассивЭлементов = Новый Массив();
	
	Для Каждого ЭлементСтруктуры из СтруктураПараметров Цикл
		МассивЭлементов.Добавить(ЭлементСтруктуры.Ключ);
	КонецЦикла;

	Если ТолькоПросмотр Тогда 	
				
		ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", Истина);
		
	КонецЕсли;  
	
	Если Параметры.Свойство("СкрыватьПолеКомментарийВФорме") Тогда
		ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, "Комментарий", "Видимость", Ложь);
	КонецЕсли;
	
	Для Каждого Элемент Из МассивЭлементов Цикл
		МетаданныеДокумента = Метаданные.Документы[Параметры.ТипОбъекта];
		ИмяРеквизита = Элемент;
		Если НЕ ОбщегоНазначенияБК.ЕстьРеквизитДокумента(ИмяРеквизита,МетаданныеДокумента) И ИмяРеквизита <> "ИнвентаризационнаяКомиссия" Тогда
			ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Элемент, "Видимость", Ложь);		
		КонецЕсли;  
		
	КонецЦикла;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИзменяемыеРеквизиты(Источник)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ДатаНачалаИнвентаризации",               Источник.ДатаНачалаИнвентаризации);
	СтруктураПараметров.Вставить("ДатаОкончанияИнвентаризации",            Источник.ДатаОкончанияИнвентаризации);
	СтруктураПараметров.Вставить("ДокументОснованиеВид",      	   		   Источник.ДокументОснованиеВид);
	СтруктураПараметров.Вставить("ДокументОснованиеДата",      	   		   Источник.ДокументОснованиеДата);
	СтруктураПараметров.Вставить("ДокументОснованиеНомер",         		   Источник.ДокументОснованиеНомер);
	СтруктураПараметров.Вставить("ИнвентаризационнаяКомиссия",       	   Источник.ИнвентаризационнаяКомиссия);
	СтруктураПараметров.Вставить("ПричинаПроведенияИнвентаризации",        Источник.ПричинаПроведенияИнвентаризации);
	СтруктураПараметров.Вставить("Основание",        					   Источник.Основание);
			
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли  Модифицированность И НЕ ПеренестиВДокумент Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемФормыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
	Если Отказ Тогда
		ПеренестиВДокумент = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ПеренестиВДокумент И Модифицированность Тогда
		СтруктураРезультат = Новый Структура("
			|ДатаНачалаИнвентаризации, ДатаОкончанияИнвентаризации,
			|ПерезаполнитьДокументПоОснованию,
			|ДокументОснованиеВид,
			|ДокументОснованиеДата,
			|ДокументОснованиеНомер,
			|ИнвентаризационнаяКомиссия,
			|Основание,
			|ПричинаПроведенияИнвентаризации");
		
		ЗаполнитьЗначенияСвойств(СтруктураРезультат, ЭтаФорма);
		
		ОповеститьОВыборе(СтруктураРезультат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВидВходящегоДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВидДокумента", Элемент.ТекстРедактирования);
	
	ОткрытьФорму("Справочник.ВидыПервичныхДокументов.ФормаВыбора", СтруктураПараметров, ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ФизическиеЛица.Форма.ФормаВыбора" Тогда
		
		Для Каждого СтрокаМассива Из ВыбранноеЗначение Цикл
			
			СтрокиТабличногоПоля = ИнвентаризационнаяКомиссия.НайтиСтроки(Новый Структура("ФизЛицо", СтрокаМассива));
			
			Если СтрокиТабличногоПоля.Количество() > 0 Тогда
				
				ТекстСообщения = НСтр("ru='Физическое лицо < %1 > уже выбрано!'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, 
					СтрокаМассива);
				
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,, "Объект");
	
			Иначе
				НоваяСтрока = ИнвентаризационнаяКомиссия.Добавить();	
				НоваяСтрока.ФизЛицо = СтрокаМассива;
				
				Если ИнвентаризационнаяКомиссия.Количество() = 1 Тогда
					НоваяСтрока.Председатель = Истина;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборКомиссии(Команда)
	
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ИнвентаризационнаяКомиссия

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Копирование Тогда
		
		Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо = Неопределено;
		Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.Председатель = Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если НЕ ОтменаРедактирования Тогда
		
		УсловияПоиска = Новый Структура("ФизЛицо", Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо);
		СтрокиФЛ = ИнвентаризационнаяКомиссия.НайтиСтроки(УсловияПоиска);
		
		Если СтрокиФЛ.Количество() > 1 Тогда
			
			Отказ = Истина;
			ТекстПредупреждения = НСтр("ru='Физическое лицо %1 уже включено в состав комиссии!'");
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", 
															Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо);
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо = Неопределено;
			ТекущийЭлемент = Элементы.ИнвентаризационнаяКомиссияФизЛицо;
			
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НЕ ОтменаРедактирования Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ПроверитьФлагиПредседателя(Элемент.ТекущиеДанные);
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПредседательПриИзменении(Элемент)
	
	Для Каждого Строка Из ИнвентаризационнаяКомиссия Цикл
			
		Если НЕ (Строка.ПолучитьИдентификатор() = Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ПолучитьИдентификатор()) Тогда
			
			Строка.Председатель = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияФизЛицоПриИзменении(Элемент)
	
	Если ИнвентаризационнаяКомиссия.Количество() = 1 Тогда
		
		ИнвентаризационнаяКомиссия[0].Председатель = Истина;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПослеУдаления(Элемент)
	
	Если ИнвентаризационнаяКомиссия.Количество() > 0 Тогда
		ПроверитьФлагиПредседателя(Неопределено);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьФлагиПредседателя(СтрокаТЧ)
    
	СтрокаПредседателя = ?(СтрокаТЧ <> Неопределено И СтрокаТЧ.Председатель, СтрокаТЧ, Неопределено);
	
	Для Каждого СтрокаКомиссии Из ИнвентаризационнаяКомиссия Цикл
		
		Если СтрокаКомиссии.Председатель И СтрокаПредседателя = Неопределено Тогда
			СтрокаПредседателя = СтрокаКомиссии;
			Продолжить;
		КонецЕсли;	
		
		Если СтрокаКомиссии.Председатель И СтрокаКомиссии <> СтрокаПредседателя Тогда
			СтрокаКомиссии.Председатель = Ложь;
		КонецЕсли;	
		
	КонецЦикла;	

	Если СтрокаПредседателя = Неопределено И ИнвентаризационнаяКомиссия.Количество() > 0 Тогда
		ИнвентаризационнаяКомиссия[0].Председатель = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПричинаПроведенияИнвентаризацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец,ИмяРеквизита", ЭтаФорма, "ПричинаПроведенияИнвентаризации");
	Оповещение = Новый ОписаниеОповещения("ПричинаПроведенияИнвентаризацииЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(
		Оповещение,
		ПричинаПроведенияИнвентаризации,
		НСтр("ru='Причина проведения инвентаризации'"));

КонецПроцедуры

&НаКлиенте
Процедура ПричинаПроведенияИнвентаризацииЗавершениеВвода(Строка, Параметры) Экспорт

	Если Строка <> Неопределено И ПричинаПроведенияИнвентаризации <> Строка Тогда
		
		ПричинаПроведенияИнвентаризации = Строка;
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец,ИмяРеквизита", ЭтаФорма, "Основание");
	Оповещение = Новый ОписаниеОповещения("ОснованиеСписанияЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(
		Оповещение,
		Основание,
		НСтр("ru='Основание списания'"));
		
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеСписанияЗавершениеВвода(Строка, Параметры) Экспорт

	Если Строка <> Неопределено И Основание <> Строка Тогда
		
		Основание = Строка;
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
