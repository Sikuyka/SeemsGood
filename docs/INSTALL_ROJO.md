# Установка Rojo 7 (Windows)

Studio у вас уже есть. Нужны **два** компонента: CLI на ПК и **плагин** в Studio.

## 1. Rojo CLI (Windows)

### Способ A — скачать ZIP (проще всего)

1. Откройте: https://github.com/rojo-rbx/rojo/releases/tag/v7.6.1  
2. Скачайте **`rojo-7.6.1-windows-x86_64.zip`**  
3. Распакуйте `rojo.exe` в папку, например: `C:\Tools\rojo\`  
4. Добавьте эту папку в **PATH**:
   - Win + R → `sysdm.cpl` → вкладка **Дополнительно** → **Переменные среды**
   - В «Переменные среды пользователя» выберите **Path** → **Изменить** → **Создать** → `C:\Tools\rojo`
5. Откройте **новый** PowerShell и проверьте:

```powershell
rojo --version
```

Должно показать `7.6.x`.

### Способ B — Aftman (как в этом репозитории)

1. Установите Aftman: https://github.com/LPGhatguy/aftman#installation  
2. В папке проекта `SeemsGood`:

```powershell
aftman install
```

Rojo появится в `.aftman/bin` — добавьте эту папку в PATH или вызывайте `aftman run rojo serve`.

## 2. Плагин Rojo в Roblox Studio

Выберите **один** вариант:

- **Маркетплейс (рекомендуется):**  
  https://create.roblox.com/marketplace/asset/13916111004/Rojo  
  Studio → **Plugins** → установить **Rojo**

- **Через CLI** (после установки `rojo.exe`):

```powershell
rojo plugin install
```

Перезапустите Studio.

## 3. Подключение к SeemsGood

```powershell
cd C:\path\to\SeemsGood
rojo serve
```

В Studio: плагин **Rojo** → **Connect** (порт `34872` по умолчанию).

## 4. Проверка

В Output Studio после Play должно быть: `[SeemsGood] All services started.`

## Частые проблемы

| Проблема | Решение |
|----------|---------|
| `rojo` не найден | PATH не обновлён — новый терминал / перелогин |
| Connect не работает | Запущен ли `rojo serve` в папке с `default.project.json` |
| DataStore ошибки | Game Settings → Enable Studio Access to API Services |
