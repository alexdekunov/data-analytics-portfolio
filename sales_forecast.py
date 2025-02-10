# Прогноз продаж с использованием модели ARIMA

# Импорт необходимых библиотек
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.tsa.arima.model import ARIMA
from sklearn.metrics import mean_squared_error

# Загрузка данных
# Предположим, что у нас есть данные о продажах в формате CSV
# Дата и количество продаж
data = pd.read_csv('sales_data.csv', parse_dates=['date'], index_col='date')

# Проверка данных
print(data.head())

# Визуализация данных
plt.figure(figsize=(10, 6))
plt.plot(data)
plt.title('Исторические данные о продажах')
plt.xlabel('Дата')
plt.ylabel('Продажи')
plt.show()

# Разделение данных на обучающую и тестовую выборки
train_size = int(len(data) * 0.8)
train, test = data[:train_size], data[train_size:]

# Обучение модели ARIMA
# Параметры (p, d, q) можно подобрать с помощью анализа ACF/PACF или автоматического подбора
model = ARIMA(train, order=(5, 1, 0))  # Пример параметров (p=5, d=1, q=0)
model_fit = model.fit()

# Прогнозирование на тестовой выборке
forecast = model_fit.forecast(steps=len(test))

# Визуализация прогноза
plt.figure(figsize=(10, 6))
plt.plot(train.index, train, label='Обучающая выборка')
plt.plot(test.index, test, label='Тестовая выборка')
plt.plot(test.index, forecast, label='Прогноз')
plt.title('Прогноз продаж с использованием ARIMA')
plt.xlabel('Дата')
plt.ylabel('Продажи')
plt.legend()
plt.show()

# Оценка качества модели
mse = mean_squared_error(test, forecast)
print(f'Среднеквадратичная ошибка (MSE): {mse}')

# Прогнозирование на будущее
future_steps = 30  # Прогноз на 30 дней вперёд
future_forecast = model_fit.forecast(steps=future_steps))

# Визуализация прогноза на будущее
plt.figure(figsize=(10, 6))
plt.plot(data.index, data, label='Исторические данные')
future_dates = pd.date_range(start=data.index[-1], periods=future_steps + 1, freq='D')[1:]
plt.plot(future_dates, future_forecast, label='Прогноз на будущее')
plt.title('Прогноз продаж на будущее')
plt.xlabel('Дата')
plt.ylabel('Продажи')
plt.legend()
plt.show()
