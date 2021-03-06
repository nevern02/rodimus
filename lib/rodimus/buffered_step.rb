module Rodimus

  class BufferedStep < Step
    # The maximum size of the buffer
    attr_accessor :buffer_size
    attr_reader   :buffer

    def initialize(buffer_size = 100)
      super()
      @buffer_size = buffer_size
      @buffer      = []
    end

    def close_descriptors # override
      flush if buffer.any?
      super
    end

    def handle_output(transformed_row) # override
      buffer << transformed_row

      if buffer.length >= buffer_size
        flush
      end
    end

    # Flush the contents of the buffer to the outgoing data stream
    def flush
      outgoing.puts(buffer.join("\n"))
      @buffer = []
    end
  end

end
