module Entities
  def self.table
    {
      remains: {
        symbol: '░',
        style: 'remains',
        bgstyle: 'bgremains'
      },
      marker: {
        symbol: nil,
        style: nil,
        bgstyle: 'bgmarker'
      }
    }
  end
end