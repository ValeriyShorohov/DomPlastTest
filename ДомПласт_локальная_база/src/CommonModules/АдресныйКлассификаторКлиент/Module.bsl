////////////////////////////////////////////////////////////////////////////////
// АдресныйКлассификатор: содержит алгоритмы работы с адресным классификатором, 
//   исполняемые на клиенте
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ЗагрузитьАдресныйКлассификатор(Знач ПараметрыЗагрузки = Неопределено) Экспорт
	
	ОткрытьФорму("РегистрСведений.АдресныйКлассификатор.Форма.ЗагрузкаАдресногоКлассификатора", ПараметрыЗагрузки);
		
КонецПроцедуры

// Вызывает форму очистки сведений адресного классификатора по адресным объектам
//
// Параметры:
//     Владелец - ФормаКлиентскогоПриложения - форма, из которой осуществляется очистка адресного классификатора.
//
Процедура ОчиститьКлассификатор(Владелец = Неопределено) Экспорт
	
	ОткрытьФорму("РегистрСведений.АдресныйКлассификатор.Форма.ОчисткаАдресногоКлассификатора", , Владелец);
		
КонецПроцедуры

// Открывает форму выбора уровня - разрыв взаимозависимости систем
//
Функция ОткрытьФормуВыбораКАТО(ПараметрыФормы = Неопределено, Владелец = Неопределено, Уникальность = Неопределено, Окно = Неопределено, НавигационнаяСсылка = Неопределено, ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	Возврат ОткрытьФорму("РегистрСведений.АдресныйКлассификатор.Форма.ФормаВыбора", ПараметрыФормы, Владелец, 
		Уникальность, Окно, НавигационнаяСсылка, ОписаниеОповещенияОЗакрытии);
		
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Вызывает диалог выбора каталога
// 
// Параметры:
//     Форма - ФормаКлиентскогоПриложения - вызывающий объект
//     ПутьКДанным          - Строка  - полное имя реквизита формы, содержащего значение каталога. Например "РабочийКаталог" 
//                                      или "Объект.КаталогИзображений"
//     Заголовок            - Строка - Заголовок для диалога 
//     СтандартнаяОбработка - Булево - для использования в обработчике "ПриНачалаВыбора". Будет заполнено значением Ложь
//
Процедура ВыбратьФайл(Знач Форма, Знач ПутьКДанным, Знач Заголовок = Неопределено, СтандартнаяОбработка = Ложь,ОповещениеЗавершения = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;

	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Выберите файл с классификаторами'");
	ДиалогВыбораФайла.Фильтр    = НСтр("ru = 'Файл классификаторов (*.xm[)|*.xml'"); 
	ДиалогВыбораФайла.ПолноеИмяФайла = ПутьКданным;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения",ОповещениеЗавершения); 
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыбратьФайлЗавершениеКонтроляРасширенияРаботыСФайлами",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(
		ОписаниеОповещения,
		ДиалогВыбораФайла); 	
КонецПроцедуры

// Завершение немодального выбора каталога
//
Процедура ВыбратьФайлЗавершениеКонтроляРасширенияРаботыСФайлами(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Форма.АдресЗагрузки = ВыбранныеФайлы[0];
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, ВыбранныеФайлы);
	КонецЕсли;

КонецПроцедуры

Функция МожноИзменятьАдресныйКлассификатор()
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	Возврат НЕ ПараметрыРаботыКлиента.РазделениеВключено;
	
КонецФункции

#Область ЗагрукаАдресногоКлассификатора
// Проверка на доступность всех необходимых файлов для загрузки.
//
// Параметры:
//     КодыРегионов      - Массив    - содержит числовые значения - коды регионов-субъектов РФ (для последующей
//                                     загрузки).
//     Каталог           - Строка    - каталог с проверяемыми файлами.
//     ПараметрыЗагрузки - Структура:
//         * КодИсточникаЗагрузки - Строка - описывает набор анализируемых файлов. Возможные значения: "КАТАЛОГ",
//                                           "САЙТ", "ИТС".
//         * ПолеОшибки           - Строка - имя реквизита для привязки сообщений об ошибке.
//
Процедура АнализДоступностиФайловКлассификатораВКаталоге(ОписаниеЗавершения, КодыОбластей, АдресФайла, ПараметрыЗагрузки) Экспорт
	
	СтруктураФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(АдресФайла);
	
	РабочийКаталог = СтруктураФайла.Путь;
	ИмяФайла       = СтруктураФайла.Имя;

	ПолеОшибки = ПараметрыЗагрузки.ПолеОшибки;
	
	Результат = Новый Структура;
	Результат.Вставить("КодыОбластей",    КодыОбластей);
	Результат.Вставить("ЕстьВсеФайлы",    Истина);
	Результат.Вставить("Ошибки",          Неопределено);
	Результат.Вставить("ФайлыПоОбластям", Новый Соответствие);
	
	ДополнительныеПараметры = ПараметрыЗагрузки();
	ДополнительныеПараметры.ОписаниеЗавершения = ОписаниеЗавершения;
	ДополнительныеПараметры.ПолеОшибки         = ПолеОшибки;
	ДополнительныеПараметры.РабочийКаталог     = РабочийКаталог;
	ДополнительныеПараметры.Результат.КодыОбластей = КодыОбластей;
	
	ДополнительныеПараметры.Результат.ФайлыПоОбластям.Вставить("kato", РабочийКаталог);
	ДополнительныеПараметры.Вставить("ИмяФайла",      ИмяФайла); 
	ДополнительныеПараметры.Вставить("КоличествоОбластей", 1);

             	
	ОписаниеОповещения = Новый ОписаниеОповещения("АнализДоступностиФайловКлассификатораВКаталогеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, 0);
	
КонецПроцедуры

// Параметры загрузки файлов.
// 
// Возвращаемое значение:
//   Структура:
//   * ИндексРегиона - Неопределено - индекс региона;
//   * ИмяФайла - Строка - имя файла региона;
//   * КодРегиона - Неопределено -цифровой код региона;
//   * ПолеОшибки - Строка - элементы формы с ошибкой; 
//   * РабочийКаталог - Строка - каталог загрузки файлов адресных сведений;
//   * Результат - Структура:
//     ** КодыРегионов - Массив -коды регионов;
//     ** ЕстьВсеФайлы - Булево - признак наличия файлов;
//     ** Ошибки - Массив - список ошибок;
//     ** ФайлыПоРегионам - Соответствие - имя файла и путь к нему. 
//   * ОписаниеЗавершения - Строка - описание завершения;
//   * ОтсутствующиеФайлы - Соответствие - список отсутствующих файлов.
//
Функция ПараметрыЗагрузки()
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОтсутствующиеФайлы", Новый Соответствие);
	ДополнительныеПараметры.Вставить("ОписаниеЗавершения", "");

	ДополнительныеПараметры.Вставить("РабочийКаталог",     "");
	ДополнительныеПараметры.Вставить("ПолеОшибки",         "");
	
	ДополнительныеПараметры.Вставить("КодОбласти",    Неопределено);
	ДополнительныеПараметры.Вставить("ИмяФайла",      "");    
	ДополнительныеПараметры.Вставить("ИндексОбласти",0);
	ДополнительныеПараметры.Вставить("КоличествоОбластей", 0);
		
	Результат = Новый Структура;
	Результат.Вставить("КодыОбластей",    Новый Массив);
	Результат.Вставить("ЕстьВсеФайлы",    Истина);
	Результат.Вставить("Ошибки",          Неопределено);
	Результат.Вставить("ФайлыПоОбластям", Новый Соответствие);   

	ДополнительныеПараметры.Вставить("Результат", Результат);
	
	Возврат ДополнительныеПараметры
	
КонецФункции

Процедура АнализДоступностиФайловКлассификатораВКаталогеЗавершение(ИндексОбласти, ДополнительныеПараметры) Экспорт
	
	Если ИндексОбласти <= ДополнительныеПараметры.КоличествоОбластей - 1 Тогда
		
		Если  ДополнительныеПараметры.КоличествоОбластей = 1 Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("АнализДоступностиФайловКлассификатораВКаталогеПослеПоискаФайлов", ЭтотОбъект, ДополнительныеПараметры);
			НачатьПоискФайлов(ОписаниеОповещения, ДополнительныеПараметры.РабочийКаталог, МаскаФайла(ДополнительныеПараметры.ИмяФайла));
		Иначе
			
			КодОбласти = ДополнительныеПараметры.Результат.КодыОбластей.Получить(ИндексОбласти);
			// Набор файлов для каждого региона.
			ДополнительныеПараметры.Результат.ФайлыПоОбластям[КодОбласти.Значение] = Новый Массив;
			
			ИмяФайла = Формат(КодОбласти.Значение, "ЧЦ=2; ЧН=; ЧВН=; ЧГ=") + ".ZIP";
			ДополнительныеПараметры.Вставить("КодРегиона",    КодОбласти.Значение);
			ДополнительныеПараметры.Вставить("ИмяФайла",      ИмяФайла);
			ДополнительныеПараметры.Вставить("ИндексРегиона", ИндексОбласти);
			ОписаниеОповещения = Новый ОписаниеОповещения("АнализДоступностиФайловКлассификатораВКаталогеПослеПоискаФайлов", ЭтотОбъект, ДополнительныеПараметры);
			НачатьПоискФайлов(ОписаниеОповещения, ДополнительныеПараметры.РабочийКаталог, МаскаФайла(ИмяФайла));
		КонецЕсли;
			
		
	Иначе // окончание цикла
		
		Для каждого ОтсутствующийФайл Из ДополнительныеПараметры.ОтсутствующиеФайлы Цикл
			Представление = ДополнительныеПараметры.Результат.КодыРегионов.НайтиПоЗначению(ОтсутствующийФайл.Ключ);
			
			СообщениеОбОшибке = НСтр("ru = 'Указанный файл не существует'") + Символы.ПС;
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ДополнительныеПараметры.Результат.Ошибки, ДополнительныеПараметры.ПолеОшибки,
				, Неопределено);
		КонецЦикла;
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеЗавершения, ДополнительныеПараметры.Результат);
		
	КонецЕсли; 
	
КонецПроцедуры

// Обработчик оповещения после вызова метода НачатьПоискФайлов
// 
// Параметры:
//   НайденныеФайлы - Массив - файлы с адресными сведениями
//   ДополнительныеПараметры - см. ПараметрыЗагрузки
// 
Процедура АнализДоступностиФайловКлассификатораВКаталогеПослеПоискаФайлов(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	СтруктураФайла = Новый Структура("Существует, Имя, ИмяБезРасширения, ПолноеИмя, Путь, Расширение", Ложь);
	Если НайденныеФайлы.Количество() > 0 Тогда		
		СтруктураФайла.Существует = Истина;
		ЗаполнитьЗначенияСвойств(СтруктураФайла, НайденныеФайлы[0]);
	КонецЕсли;
	
	Если СтруктураФайла.Существует Тогда
		СписокПутей = ДополнительныеПараметры.Результат.ФайлыПообластям; // Массив
		СписокПутей.Вставить("kato", СтруктураФайла.ПолноеИмя);
	Иначе
		ДополнительныеПараметры.Результат.ЕстьВсеФайлы = Ложь;
		ДополнительныеПараметры.ОтсутствующиеФайлы.Вставить("kato", ДополнительныеПараметры.ИмяФайла); 

	КонецЕсли;
	
	АнализДоступностиФайловКлассификатораВКаталогеЗавершение(ДополнительныеПараметры.ИндексОбласти + 1, ДополнительныеПараметры);
    	
КонецПроцедуры

Функция МаскаФайла(ИмяФайла)
	
	НеУчитыватьРегистр = ОбщегоНазначенияКлиент.ЭтоWindowsКлиент();
	
	Если НеУчитыватьРегистр Тогда
		Маска = ВРег(ИмяФайла);
	Иначе
		Маска = "";
		Для Позиция = 1 По СтрДлина(ИмяФайла) Цикл
			Символ = Сред(ИмяФайла, Позиция, 1);
			ВерхнийРегистр = ВРег(Символ);
			НижнийРегистр  = НРег(Символ);
			Если ВерхнийРегистр = НижнийРегистр Тогда
				Маска = Маска + Символ;
			Иначе
				Маска = Маска + "[" + ВерхнийРегистр + НижнийРегистр + "]";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Маска;
	
КонецФункции

#КонецОбласти 