
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоВебКлиент = ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
	
	ВыполнитьПроверкуПравДоступа("СохранениеДанныхПользователя", Метаданные);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	Если ЭтоВебКлиент Тогда
		Элементы.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы.Видимость = Ложь;
	Иначе
		Элементы.ГруппаУстановитьРасширениеРаботыСФайламиНаКлиенте.Видимость = Ложь;
	КонецЕсли;
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.Пользователи
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	Элементы.СведенияОПользователе.Заголовок = АвторизованныйПользователь;
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.РаботаСФайлами
	СпрашиватьРежимРедактированияПриОткрытииФайла = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов",
		"СпрашиватьРежимРедактированияПриОткрытииФайла",
		Истина);
	
	ДействиеПоДвойномуЩелчкуМыши = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов",
		"ДействиеПоДвойномуЩелчкуМыши",
		Перечисления.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьФайл);
	
	СпособСравненияВерсийФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСравненияФайлов",
		"СпособСравненияВерсийФайлов",
		Перечисления.СпособыСравненияВерсийФайлов.ПустаяСсылка());
	
	ПоказыватьПодсказкиПриРедактированииФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьПодсказкиПриРедактированииФайлов",
		Ложь);
	
	ПоказыватьИнформациюЧтоФайлНеБылИзменен = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьИнформациюЧтоФайлНеБылИзменен",
		Ложь);
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
		Истина);
	
	ПоказыватьКолонкуРазмер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьКолонкуРазмер",
		Ложь);
	
	// Заполнение настроек открытия файлов.
	СтрокаНастройки = НастройкиОткрытияФайлов.Добавить();
	СтрокаНастройки.ТипФайла = Перечисления.ТипыФайловДляВстроенногоРедактора.ТекстовыеФайлы;
	
	СтрокаНастройки.Расширение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов\ТекстовыеФайлы",
		"Расширение",
		"TXT XML INI");
	
	СтрокаНастройки.СпособОткрытия = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов\ТекстовыеФайлы",
		"СпособОткрытия",
		Перечисления.СпособыОткрытияФайлаНаПросмотр.ВоВстроенномРедакторе);
	
	Если ЭтоВебКлиент Тогда
		Элементы.ПоказыватьЗанятыеФайлыПриЗавершенииРаботы.Видимость      = Ложь;
	КонецЕсли;
	
	Если ЭтоВебКлиент Или ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Элементы.НастройкаСканирования.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ЭлектроннаяПодпись
	Элементы.НастройкиЭлектроннойПодписиИШифрования.Видимость =
		ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись
	
	ЗначениеРабочейДаты = ОбщегоНазначения.РабочаяДатаПользователя();

	Если ЗначениеЗаполнено(ЗначениеРабочейДаты) Тогда
		ИспользоватьТекущуюДатуКомпьютера = 1;
	Иначе
		ИспользоватьТекущуюДатуКомпьютера = 0;
		ЗначениеРабочейДаты = '0001-01-01';
	КонецЕсли;

	// НастройкиИнтерфейса
	Элементы.Интерфейс.Видимость = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	
	НастройкиКлиентскогоПриложения = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить("Общее/НастройкиКлиентскогоПриложения", "");
	Если НастройкиКлиентскогоПриложения <> Неопределено Тогда 
		ВариантМасштабаФорм   = НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения;
	Иначе 
		ВариантМасштабаФорм   = "Авто";
	КонецЕсли;
	// Конец НастройкиИнтерфейса
	
	Элементы.ГруппаИнтеграция1СБухфон.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОнлайнПоддержку");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
#Если ВебКлиент Тогда	
	НапоминатьОбУстановкеРасширенияРаботыСФайлами = ОбщегоНазначенияКлиент.ПредлагатьУстановкуРасширенияРаботыСФайлами();
	ОбновитьГруппуУстановкиРасширенияРаботыСФайлами();
#КонецЕсли	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Страница Главное

&НаКлиенте
Процедура СведенияОПользователе(Команда)
	
	ПоказатьЗначение(, АвторизованныйПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерсональнаяНастройкаПроксиСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", Новый Структура("НастройкаПроксиНаКлиенте", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиенте(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуУстановкиРасширенияРаботыСФайлами()
	
	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("ОбновитьГруппуУстановкиРасширенияРаботыСФайламиЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы(Команда)
	
	ОбновитьПовторноИспользуемыеЗначения();
	ТекущееАктивноеОкно = АктивноеОкно();
	ОбновитьИнтерфейс();
	Если ТекущееАктивноеОкно <> Неопределено Тогда
		ТекущееАктивноеОкно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЭлектроннойПодписиИШифрования(Команда)
	
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьТекущуюДатуКомпьютераПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
	Если ИспользоватьТекущуюДатуКомпьютера = 0 Тогда
		ЗначениеРабочейДаты = '0001-01-01';
	ИначеЕсли ИспользоватьТекущуюДатуКомпьютера = 1 Тогда
		ЗначениеРабочейДаты = ТекущаяДата();
	КонецЕсли;
	Модифицированность = Истина;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница Печать

&НаКлиенте
Процедура ЗадатьДействиеПриВыбореМакетаПечатнойФормы(Команда)
	
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница РаботаСФайлами

&НаКлиенте
Процедура НастройкаРабочегоКаталога(Команда)
	
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиРабочегоКаталога();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСканирования(Команда)
	
	ФайловыеФункцииКлиент.ОткрытьФормуНастройкиСканирования();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ПараметрыКлиента = Новый Структура;
	#Если ВебКлиент Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация;
		ПараметрыКлиента.Вставить("ИдентификаторКлиента", СистемнаяИнформация.ИдентификаторКлиента);
	#КонецЕсли
	ЗаписатьНастройкиНаСервере(ПараметрыКлиента);
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.ЗначениеРабочейДаты.Доступность  = Форма.ИспользоватьТекущуюДатуКомпьютера = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение(ДополнительныеПараметры) Экспорт
	
	ОбновитьГруппуУстановкиРасширенияРаботыСФайлами();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуУстановкиРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = ?(Подключено,
		Элементы.ГруппаРасширениеРаботыСФайламиУстановлено,
		Элементы.ГруппаРасширениеРаботыСФайламиНеУстановлено);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиНаСервере(ПараметрыКлиента)
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	СохранитьСвойстваКоллекции("ОбщиеНастройкиПользователя", ЭтотОбъект,
		"ЗапрашиватьПодтверждениеПриЗавершенииПрограммы");
	Если ПараметрыКлиента.Свойство("ИдентификаторКлиента") Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами",
			ПараметрыКлиента.ИдентификаторКлиента,
			НапоминатьОбУстановкеРасширенияРаботыСФайлами);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.РаботаСФайлами
	СохранитьСвойстваКоллекции("НастройкиОткрытияФайлов", ЭтотОбъект,
		"ДействиеПоДвойномуЩелчкуМыши,
		|СпрашиватьРежимРедактированияПриОткрытииФайла");
	СохранитьСвойстваКоллекции("НастройкиПрограммы", ЭтотОбъект,
		"ПоказыватьПодсказкиПриРедактированииФайлов,
		|ПоказыватьЗанятыеФайлыПриЗавершенииРаботы,
		|ПоказыватьКолонкуРазмер,
		|ПоказыватьИнформациюЧтоФайлНеБылИзменен");
	СохранитьСвойстваКоллекции("НастройкиСравненияФайлов", ЭтотОбъект,
		"СпособСравненияВерсийФайлов");
	Если НастройкиОткрытияФайлов.Количество() >= 1 Тогда
		СохранитьСвойстваКоллекции("НастройкиОткрытияФайлов\ТекстовыеФайлы", НастройкиОткрытияФайлов[0],
			"Расширение,
			|СпособОткрытия");
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// НастройкиИнтерфейса
	НастройкиКлиентскогоПриложения = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить("Общее/НастройкиКлиентскогоПриложения", "");
	Если ПустаяСтрока(ВариантМасштабаФорм) Тогда 
		ВариантМасштабаФорм = "Авто";
	КонецЕсли;
	
	Если НастройкиКлиентскогоПриложения <> Неопределено Тогда 
		НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения   = ВариантМасштабаФормКлиентскогоПриложения[ВариантМасштабаФорм];
	Иначе 
		НастройкиКлиентскогоПриложения = Новый НастройкиКлиентскогоПриложения;
		НастройкиКлиентскогоПриложения.ВариантИнтерфейсаКлиентскогоПриложения 	= ВариантИнтерфейсаКлиентскогоПриложения.Такси;
		НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения = ВариантМасштабаФормКлиентскогоПриложения[ВариантМасштабаФорм];
		НастройкиКлиентскогоПриложения.РежимОткрытияФормПриложения 				= РежимОткрытияФормПриложения.Закладки;
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить(
		"Общее/НастройкиКлиентскогоПриложения",
		"",
		НастройкиКлиентскогоПриложения);
	// Конец НастройкиИнтерфейса
	
	Если ИспользоватьТекущуюДатуКомпьютера = 0 Тогда
		ЗначениеРабочейДатыДляСохранения  = '0001-01-01';
	Иначе
		ЗначениеРабочейДатыДляСохранения  = ЗначениеРабочейДаты;
	КонецЕсли;
	ОбщегоНазначения.УстановитьРабочуюДатуПользователя(ЗначениеРабочейДатыДляСохранения);

	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

&НаСервере
Процедура СохранитьСвойстваКоллекции(КлючОбъекта, Коллекция, ИменаРеквизитов)
	СтруктураРеквизитов = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Коллекция);
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
