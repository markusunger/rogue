module Entities
  def self.table
    {
      invisible: {
        symbol: '',
        style: '',
        bgstyle: '',
        priority: 0
      },
      remains: {
        symbol: '░',
        style: 'remains',
        bgstyle: 'bgremains',
        priority: 1
      },
      marker: {
        symbol: nil,
        style: nil,
        bgstyle: 'bgmarker',
        priority: 99
      }
    }
  end
end