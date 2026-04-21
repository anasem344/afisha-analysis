-- ============================================
-- Afisha Ticket Sales Analysis (SQL Part)
-- Author: Anastasia
-- Description:
-- Initial data exploration and validation:
-- - schema structure and relationships
-- - data quality checks (duplicates, nulls)
-- - basic aggregations and distributions
-- ============================================



-- ============================================
-- 1. Schema overview
-- ============================================



--1. Смотрим все ключи (PK и FK) в схеме, чтобы понять структуру связей между таблицами
SELECT table_schema, 
       table_name, 
       column_name,
       constraint_name
FROM information_schema.key_column_usage
WHERE table_schema = 'afisha';
-- Первичные ключи (PK) в таблицах city.city_id, events.event_id, purchases.order_id,
-- regions.region_id, venues.venue_id
-- Внешние ключи: city.region_id d-regions, events.city_id - city, 
-- events.venue_id - venues, purchases.event_id - events. Везде тип связи 'один ко многим'
-- Аномалия найдена в таблице purchases там есть еще один внешний ключ на event_id

-- 2. Чтобы убедиться, что данные в таблицах соответствуют описанию,
-- смотрим содержимое таблиц

--2.1 Смотрим содержание таблицы purchases
SELECT * FROM purchases LIMIT 10;
--1	3ebd0c4b59f6bdd	2024-08-08 00:00:00.000	2024-08-08 15:01:11.000	555432	нет	16	rub	mobile	568.43	Облачко	2	5684.33
--30	1a66f181a803c75	2024-09-05 00:00:00.000	2024-09-05 19:44:21.000	149337	нет	16	rub	mobile	575.08	Край билетов	2	6389.8
--59	1a66f181a803c75	2024-07-25 00:00:00.000	2024-07-25 10:09:41.000	269938	нет	12	rub	desktop	402.51	Лови билет!	4	6708.45
--88	7997823870f2b1b	2024-09-26 00:00:00.000	2024-09-26 16:03:44.000	561834	нет	18	rub	mobile	487.94	Мой билет	2	3753.35
--117	1c5bac640c12e86	2024-09-15 00:00:00.000	2024-09-15 14:18:07.000	568660	нет	0	rub	mobile	8.95	Лови билет!	2	447.38
--146	1c5bac640c12e86	2024-10-06 00:00:00.000	2024-10-06 13:39:42.000	578596	нет	0	rub	mobile	5.97	Лови билет!	2	199.08
--175	1c5bac640c12e86	2024-09-15 00:00:00.000	2024-09-15 12:38:21.000	568660	нет	0	rub	mobile	17.9	Лови билет!	4	894.76
--204	c31e4e1f23ea0a9	2024-07-13 00:00:00.000	2024-07-13 12:30:17.000	508702	нет	12	rub	mobile	727.03	Билеты в руки	4	14540.6
--233	c31e4e1f23ea0a9	2024-07-13 00:00:00.000	2024-07-13 00:03:19.000	508702	нет	12	rub	mobile	363.51	Билеты в руки	2	7270.3
--262	110125b4a429b43	2024-07-21 00:00:00.000	2024-07-21 14:51:41.000	284467	нет	6	rub	mobile	427.01	Билеты без проблем	3	8540.19

--Данные соответствуют описанию


--2.2 Смотрим содержание таблицы events
SELECT * FROM events LIMIT 10;
--4436	e4f26fba-da77-4c61-928a-6c3e434d793f	спектакль	театр	№4893	2	1600
--5785	5cc08a60-fdea-4186-9bb2-bffc3603fb77	спектакль	театр	№1931	54	2196
--8817	8e379a89-3a10-4811-ba06-ec22ebebe989	спектакль	театр	№4896	2	4043
--8849	682e3129-6a32-4952-9d8a-ef7f60d4c247	спектакль	театр	№4960	213	1987
--8850	d6e99176-c77f-4af0-9222-07c571f6c624	спектакль	театр	№4770	55	4230
--8858	08008ffd-331c-4d77-8aad-c91691f87388	спектакль	театр	№896	213	2148
--8863	2dc56536-e5ae-4d3a-9f00-f39c0ebe5b65	спектакль	театр	№3977	47	2897
--9041	1ab79186-41a8-420e-b618-dea51afd2c6f	спектакль	театр	№3582	54	3922
--9942	474ca8f8-3525-4ac0-9a98-4c1045e2fa6d	спектакль	театр	№1797	35	3975
--9992	e36939d8-ef42-4f64-bd72-5a4199dd98f5	спектакль	театр	№1774	43	3959
--Структура таблицы и данные соответвуют описанию

--Изучим разнообразие типов мероприятий в таблице
SELECT 
    event_type_main,
    COUNT(*) AS events_count
FROM events
GROUP BY event_type_main
ORDER BY events_count DESC;
--концерты	8699
--театр	7090
--другое	4662
--спорт	872
--стендап	636
--выставки	291
--ёлки	215
--фильм	19
--В таблице есть 8 типов мероприятий, основные категории концерты и театр, категория
-- другое также занимает значительную долю

 --2.3 Смотрим содержание таблицы venues
SELECT * FROM venues LIMIT 10;
-- Таблица является справочником площадок, данные соответствуют описанию

--2.4 Смотрим содержание таблицы city
SELECT * FROM city LIMIT 10;
-- Таблица является справочником городов, названия городов анонимизированы,
-- данные соответствуют описанию

--2.5 Смотрим содержание таблицы regions
SELECT * FROM regions LIMIT 10;
-- Таблица является справочником регионов, названия анонимизированы,
-- данные соответствуют описанию


-- 3. Считаем объём данных в каждой таблице
SELECT 'purchases' AS table_name, COUNT(*) AS rows_count FROM purchases
UNION ALL
SELECT 'events', COUNT(*) FROM events
UNION ALL
SELECT 'venues', COUNT(*) FROM venues
UNION ALL
SELECT 'city', COUNT(*) FROM city
UNION ALL
SELECT 'regions', COUNT(*) FROM regions;
-- purchases	292034
-- events	22484
-- venues	3228
-- city	353
-- regions	81

--Таблица с фактическими данными - purchases (в ней 292 тыс записей), остальные справочные таблицы


-- ============================================
-- 2. Data quality checks
-- ============================================


-- 4. Проверим уникальность идентификаторов во всех таблицах

-- 4.1 в таблице purchases
SELECT order_id, COUNT(*)
FROM purchases
GROUP BY order_id
HAVING COUNT(*) > 1;
-- Повторющихся id не найдено 

-- 4.2 в таблице events
SELECT event_id, COUNT(*)
FROM events
GROUP BY event_id
HAVING COUNT(*) > 1;
-- Повторющихся id не найдено

-- 4.3 в таблице city
SELECT city_id, COUNT(*)
FROM city
GROUP BY city_id
HAVING COUNT(*) > 1;
-- Повторющихся id не найдено

-- 4.4 в таблице regions
SELECT region_id, COUNT(*)
FROM regions
GROUP BY region_id
HAVING COUNT(*) > 1;
-- Повторющихся id не найдено

-- 4.5 в таблице venues
SELECT venue_id, COUNT(*)
FROM venues
GROUP BY venue_id
HAVING COUNT(*) > 1;
-- Повторющихся id не найдено

-- Вывод, что во всех таблицах первичные ключи уникальны, дубликатов идентификаторов не обнаружено

-- 5. Считаем пропуски в критических полях order_id, user_id, event_id

SELECT 
    COUNT(*) AS total_rows,
    COUNT(order_id) AS order_id_not_null,
    COUNT(user_id) AS user_id_not_null,
    COUNT(event_id) AS event_id_not_null,
    COUNT(total) AS total_not_null,
    COUNT(revenue) AS revenue_not_null
FROM purchases;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(event_id) AS event_id_not_null,
    COUNT(city_id) AS city_id_not_null,
    COUNT(venue_id) AS venue_id_not_null
FROM events;

-- Вывод: event_id, city_id, venue_id полностью заполнены, количество ненулевых
-- значений = общему числу строк, нет NULL в ключевых полях


-- 6. Проверяем категориальные данные и распределение заказов по ним

-- 6.1 Провеяем типы устройств, и распределение заказов по ним
SELECT device_type_canonical, COUNT(*)
FROM purchases
GROUP BY device_type_canonical
ORDER BY COUNT(*) DESC;
--mobile	232679
--desktop	58170
--tablet	1180
--tv	3
--other	2
--Можно отметить, что в основном используются 2 типа устройств mobile, desktop, но также
-- есть и tablet, tv, other

-- 6.2 Проверем валюту и кол-во заказов в каждой валюте
SELECT currency_code, COUNT(*)
FROM purchases
GROUP BY currency_code;
--kzt	5073
--rub	286961
--В данных присутствуют 2 валюты, rub основная, а также kzt


-- 6.3 Проверяем распределение по сервисам, которые продают билеты
SELECT service_name, COUNT(*)
FROM purchases
GROUP BY service_name
ORDER BY COUNT(*) DESC;
--Билеты без проблем	63932
--Лови билет!	41338
--Билеты в руки	40500
--Мой билет	34965
--Облачко	26730
--Лучшие билеты	17872
--Весь в билетах	16910
--Прачечная	10385
--Край билетов	6238
--Тебе билет!	5242
--Яблоко	5057
--Дом культуры	4514
--За билетом!	2877
--Городской дом культуры	2747
--Show_ticket	2208
--Мир касс	2171
--Быстробилет	2010
--Выступления.ру	1621
--Восьмёрка	1126
--Crazy ticket!	796
--Росбилет	544
--Шоу начинается!	499
--Быстрый кассир	381
--Радио ticket	380
--Телебилет	321
--КарандашРУ	133
--Реестр	130
--Билет по телефону	85
--Вперёд!	81
--Дырокол	74
--Кино билет	67
--Цвет и билет	61
--Тех билет	22
--Лимоны	8
--Зе Бест!	5
--Билеты в интернете	4

--Рынок высоко фрагментирован, основная доля приходится на несколько крупных сервисов: 
--«Билеты без проблем», «Лови билет!», «Билеты в руки» и «Мой билет».
--При этом большое кол-во небольших операторов с меньшим количеством заказов, которые, возможно,
-- при дальнейшем анализе стоит объединить в категорию 'другое'

-- 7. Проанализируем показатели выручки на наличие аномальных значений
---- 7.1 Посмотрим общую статистику по выручке

SELECT 
    COUNT(*) AS total_orders,
    ROUND(MIN(revenue)::numeric, 2) AS min_revenue,
    ROUND(MAX(revenue)::numeric, 2) AS max_revenue,
    ROUND(AVG(revenue)::numeric, 2) AS avg_revenue,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue)::numeric,
        2
    ) AS median_revenue
FROM purchases;
--total_orders 292034	
--min_revenue - 90.76	
--max_revenue 81174.5
--avg_revenue 624.83
--median_revenue 355.34

-- Анализ выручки показал наличие аномалий: отрицательные значения revenue (-90.76), выбросы вправо так как 
-- максимальные значения достигают 81174.54, а среднее значение значительно выше медианы (355.34), что говорит
-- о правостороннем смещении распределения, и выбросах справа

-- 7.2 Отдельно изучим, отрицательные значения выручки

SELECT 
    COUNT(*) AS negative_revenue
FROM purchases
WHERE revenue <= 0 OR revenue IS NULL;
-- Количество проблемных записей: 6153, нужно их фильтровать при дальнейших подсчетах (возможной причиной
-- является оформление возвратов, тогда записи все равно подлежат исключению или ошибками при сборе информации)

-- 7.3 Для дальнейшего налаиза необходимо взять сабсет, с очищенными от аномалий данными
WITH clean_data AS (
    SELECT *
    FROM purchases
    WHERE revenue > 0
      AND revenue <= (
          SELECT PERCENTILE_CONT(0.99)
          WITHIN GROUP (ORDER BY revenue::numeric)
          FROM purchases
          WHERE revenue > 0
      )
)
-- 7.4 Посмотрим общую статистику по выручке по очищенным данным
SELECT 
    COUNT(*) AS total_orders,
    ROUND(MIN(revenue)::numeric, 2) AS min_revenue,
    ROUND(MAX(revenue)::numeric, 2) AS max_revenue,
    ROUND(AVG(revenue)::numeric, 2) AS avg_revenue,
    ROUND(
    (PERCENTILE_CONT(0.5) 
     WITHIN GROUP (ORDER BY revenue::numeric))::numeric,
    2
) AS median_revenue
FROM clean_data;
--Объем данных сократился только на 3 процента, что не критично, но при этом возвраты/ошибки успешно убраны,
-- среднее сиало ближе к медиане.Очищенный датасет лучше отражает типичное поведение пользователей
-- и подходит для дальнейшего анализа

-- ============================================
-- 3. Exploratory analysis
-- ============================================

-- 8. Проведем анализ периода и сезонности
--8.1 Определяем период данных через минимальную и максимальную дату заказов

SELECT 
    MIN(created_dt_msk) AS min_date,
    MAX(created_dt_msk) AS max_date
FROM purchases;
-- Данные представлены за период с 01.06.2024 по 31.10.2024, период охватывает 5 месяцев (июнь–октябрь 2024 года),
-- это неполный год поэтому сезонность определить нельзя

-- 8.2 Определим количество заказов по месяцам

SELECT 
    DATE_TRUNC('month', created_dt_msk) AS month,
    COUNT(*) AS orders_count
FROM purchases
GROUP BY month
ORDER BY month;
-- 2024-06-01 00:00:00.000	34840
-- 2024-07-01 00:00:00.000	41112
-- 2024-08-01 00:00:00.000	45217
-- 2024-09-01 00:00:00.000	70265
-- 2024-10-01 00:00:00.000	100600
-- За эти 5 месяцев наблюдается выраженный рост числа заказов, максимальное значение достигается в октябре 
-- Вероятно, это связано с началом сезона после лета

-- 9. Дополнительные запросы
-- 9.1 Проверим популярности возрастных категорий

SELECT 
    age_limit,
    COUNT(*) AS orders_count
FROM events e
JOIN purchases p ON p.event_id = e.event_id
GROUP BY age_limit
ORDER BY orders_count DESC;

--16	78864
--12	62861
--0	61731
--6	52403
--18	36175
--Возрастные категории 16+ и 12+ самые популярные 

--9.2 Проверяем количество уникальных событий по разным полям

SELECT 
    COUNT(DISTINCT event_id) AS unique_event_id,
    COUNT(DISTINCT event_name_code) AS unique_event_name_code
FROM events;
--Событий по event_id больше, значит одно и то же название события может повторяться



