
Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012009Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Форма имеет возможность выгрузки в ИС СОНО 3.119.68, версия ФНО: 701.00.v5.r4 от 29.07.2009 г.";
	НоваяФорма.ДатаНачалоДействия = '20090101';
	НоваяФорма.ДатаКонецДействия  = '20091231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012010Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v6.r19 от 18.03.2010 г.";
	НоваяФорма.ДатаНачалоДействия = '20100101';
	НоваяФорма.ДатаКонецДействия  = '20101231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012011Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v7.r27 от 21.02.2011 г.";
	НоваяФорма.ДатаНачалоДействия = '20110101';
	НоваяФорма.ДатаКонецДействия  = '20111231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012012Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v8.r31 от 29.12.2011 г.";
	НоваяФорма.ДатаНачалоДействия = '20120101';
	НоваяФорма.ДатаКонецДействия  = '20121231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012013Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v9.r33 от 27.12.2012 г.";
	НоваяФорма.ДатаНачалоДействия = '20130101';
	НоваяФорма.ДатаКонецДействия  = '20131231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v10.r36 от 31.12.2013 г.";
	НоваяФорма.ДатаНачалоДействия = '20140101';
	НоваяФорма.ДатаКонецДействия  = '20141231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v12.r41 от 05.01.2015 г.";
	НоваяФорма.ДатаНачалоДействия = '20150101';
	НоваяФорма.ДатаКонецДействия  = '20151231';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v12.r42 от 18.01.2016 г.";
	НоваяФорма.ДатаНачалоДействия = '20160101';
	НоваяФорма.ДатаКонецДействия  = '20161231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012017Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v13.r45 от 25.12.2016 г.";
	НоваяФорма.ДатаНачалоДействия = '20170101';
	НоваяФорма.ДатаКонецДействия  = '20171231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012018Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v15.r47 от 01.04.2018 г.";
	НоваяФорма.ДатаНачалоДействия = '20180101';
	НоваяФорма.ДатаКонецДействия  = '20181231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v15.r49 от 26.12.2018 г.";
	НоваяФорма.ДатаНачалоДействия = '20190101';
	НоваяФорма.ДатаКонецДействия  = '20191231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012020Кв2";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v15.r52 от 21.12.2020 г.";
	НоваяФорма.ДатаНачалоДействия = '20200101';
	НоваяФорма.ДатаКонецДействия  = '20201231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012021Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средст Версия шаблона ФНО для ИС СОНО: 701.00.v15.r53 от 23.12.2021 г.";
	НоваяФорма.ДатаНачалоДействия = '20210101';
	НоваяФорма.ДатаКонецДействия  = '20211231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма7012022Кв1";
	НоваяФорма.ОписаниеОтчета     = "Расчет текущих платежей по налогу на транспортные средства. Версия шаблона ФНО для ИС СОНО: 701.00.v15.r54 от 22.12.2022 г.";
	НоваяФорма.ДатаНачалоДействия = '20220101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	ПараметрыИсполненияОтчета = Новый Структура;
	ПараметрыИсполненияОтчета.Вставить("ИспользоватьВнешниеНаборыДанных", Истина);	
	Возврат ПараметрыИсполненияОтчета;
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
		
	Возврат Новый Структура("ТаблицаРасшифровкиНалогаНаТранспорт", ПараметрыОтчета.ТаблицаРасшифровкиНалогаНаТранспорт);
	
КонецФункции