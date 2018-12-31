module Entities
  def self.table
    {
      remains: {
        symbol: '░',
        style: 'remains',
        priority: 1,
        bgstyle: 'bgremains'
      },
      marker: {
        symbol: nil,
        style: nil,
        priority: 99,
        bgstyle: 'bgmarker'
      }
    }
  end
end