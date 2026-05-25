workspace "Вырезатель секретов" "C4 модель" {
  model {
    user = person "Пользователь"
    admin = person "Администратор"

    secretCutter = softwareSystem "Вырезатель секретов" "Java-сервис, который удаляет секреты и персональные данные перед отправкой запросов к LLM-провайдерам" {
      adminPanel = container "Админ-панель" "Веб-интерфейс для управления токенами и правилами очистки" "Spring Boot"
      api = container "API очистки" "Принимает запросы, удаляет секреты и проксирует очищенные запросы" "Spring Boot"
      db = container "База конфигурации" "Хранит правила и настройки" "PostgreSQL"
      vault = container "Хранилище секретов" "Хранит API-токены провайдеров" "Vault / зашифрованное хранилище"
    }

    llm = softwareSystem "LLM-провайдер" "OpenAI / OpenRouter / Qwen"

    admin -> adminPanel "Настраивает токены и правила"
    adminPanel -> api "Сохраняет настройки"
    api -> db "Читает правила"
    api -> vault "Получает API-токен"
    user -> api "Отправляет запрос"
    api -> llm "Отправляет очищенный запрос"
    llm -> api "Возвращает ответ"
    api -> user "Возвращает ответ"
  }

  views {
    container secretCutter "containers" {
      include *
      autolayout lr
    }

    theme default
  }
}