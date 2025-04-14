defmodule MyApp.Types.ProductInfo do
  defstruct [:name, :price]

  use Ash.Type.NewType,
    subtype_of: :struct,
    constraints: [
      instance_of: __MODULE__,
      fields: [
        name: [type: :string, allow_nil?: false],
        price: [type: :money, allow_nil?: false]
      ]
    ]
end
