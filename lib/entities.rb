module Entities
  def self.table
    {
      invisible: {
        symbol: '',
        style: '',
        bgstyle: nil,
        priority: 0,
        pickable: false
      },
      remains: {
        symbol: '░',
        style: 'remains',
        bgstyle: 'bgremains',
        priority: 1,
        pickable: false
      },
      marker: {
        symbol: nil,
        style: nil,
        bgstyle: 'bgmarker',
        priority: 99,
        pickable: false
      },
      loot: {
        symbol: '¸',
        style: 'loot',
        bgstyle: nil,
        priority: 2,
        pickable: true
      }
    }
  end
end