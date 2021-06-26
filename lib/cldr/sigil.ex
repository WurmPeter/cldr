defmodule Cldr.LanguageTag.Sigil do
  @moduledoc """
  Implements a `sigil_l/2` macro to
  constructing `t:Cldr.LanguageTag` structs.

  """

  @doc """
  Handles sigil `~l` for language tags.

  ## Arguments

  * `locale_name` is either a [BCP 47](https://unicode-org.github.io/cldr/ldml/tr35.html#Identifiers)
  locale name as a string or

  * `locale_name` | `backend` where backend is a backend module name

  ### Returns

  * a `t:Cldr.LanguageTag` struct or

  * raises an exception

  ## Examples

      iex> import Cldr.LanguageTag.Sigil
      iex> ~l(en-US-u-ca-gregory)
      #Cldr.LanguageTag<en-US-u-ca-gregory [validated]>

      iex> import Cldr.LanguageTag.Sigil
      iex> ~l(en-US-u-ca-gregory|MyApp.Cldr)
      #Cldr.LanguageTag<en-US-u-ca-gregory [validated]>

  """
  defmacro sigil_l(locale_name, _opts) do
    {:<<>>, [_], [locale_name]} = locale_name

    case validate_locale(String.split(locale_name, "|")) do
      {:ok, locale_name} ->
        quote do
          unquote(Macro.escape(locale_name))
        end

      {:error, {exception, reason}} ->
        raise exception, reason
    end
  end

  defp validate_locale([locale_name, backend]) do
    backend = Module.concat([backend])
    Cldr.validate_locale(locale_name, backend)
  end

  defp validate_locale([locale_name]) do
    Cldr.validate_locale(locale_name)
  end
end
