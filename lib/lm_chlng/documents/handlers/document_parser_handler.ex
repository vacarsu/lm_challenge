defmodule LmChlng.Documents.Handlers.DocumentParserHandler do
  @behaviour Saxy.Handler

  require Logger

  def handle_event(:start_document, prolog, state) do
    Logger.info("Start parsing document #{inspect prolog}")
    {:ok, state}
  end

  def handle_event(:end_document, _data, state) do
    Logger.info("Finish parsing document")
    {:ok, state}
  end

  def handle_event(:characters, "\n", state) do
    {:ok, state}
  end

  def handle_event(:characters, chars, %{prev_chars: prev_chars, collecting: :plaintiffs} = state) do
    state =
      if not String.contains?(chars, "for") and String.contains?(chars, "Plaintiff") || String.contains?(chars, "Plaintiffs") do
        %{state | prev_chars: chars, collecting: :defendants, plaintiffs: prev_chars}
      else
        if String.length(chars) > 5 do
          %{state | prev_chars: chars}
        else
          state
        end
      end

    {:ok, state}
  end

  def handle_event(:characters, chars, %{collecting: :defendants, defendants: nil} = state) do
    state =
      if String.contains?(chars, "v.") || String.contains?(chars, "vs.") || String.contains?(chars, "-vs-") do
        %{state | prev_chars: chars, defendants: ""}
      else
        %{state | prev_chars: chars}
      end

    {:ok, state}
  end

  def handle_event(:characters, chars, %{collecting: :defendants, defendants: ""} = state) do
    state =
      if String.contains?(chars, "Defendants") || String.contains?(chars, "Defendant") do
        %{state | prev_chars: chars, collecting: nil}
      else
        if String.length(chars) > 5 do
          %{state | prev_chars: chars, defendants: "#{chars}"}
        else
          %{state | prev_chars: chars}
        end
      end

    {:ok, state}
  end

  def handle_event(:characters, chars, %{collecting: :defendants, defendants: defendants} = state) do
    state =
      if String.contains?(chars, "Defendants") || String.contains?(chars, "Defendant") do
        %{state | prev_chars: chars, collecting: nil}
      else
        if String.length(chars) > 5 do
          %{state | prev_chars: chars, defendants: "#{defendants} #{chars}"}
        else
          %{state | prev_chars: chars}
        end
      end

    {:ok, state}
  end

  def handle_event(_, _, state) do
    {:ok, state}
  end
end
