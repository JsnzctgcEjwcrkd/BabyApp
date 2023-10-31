# frozen_string_literal: true

json.array! @logs, partial: 'logs/log', as: :log
