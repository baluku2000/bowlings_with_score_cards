class BowlgamesController < ApplicationController

  STRIKE = 10
  
  def new
  end
  
  def create
    begin
      @input_frames = JSON.parse params[:frames]
    rescue JSON::ParserError => e
      # e.g. [2,]
      log_error_and_render "Invalid Input Frames" and return
    end
    
    @errmsg = ""
    
    unless validate_input_frames
    
      logger.error( @errmsg)
      flash.now[:alert] = @errmsg
      
      respond_to do |format|
        format.html { }
        format.js { open('/home/jerry/yyy.txt', 'w') { |f| f.puts @output_framescores } }
      end
      
    else

      @output_framescores = []
      compute_cumulative_framescores
      
      respond_to do |format|
        format.html { }
        format.js { open('/home/jerry/zzz.txt', 'w') { |f| f.puts @output_framescores } }
      end
      
    end
    
  end

  private
  
    # def log_error_and_render msg
    #   logger.error( msg)
    #   flash.now[:alert] = msg
    #   # render 'create'
    #  
    #   respond_to do |format|
    #     format.html { }
    #     format.js { open('/home/jerry/yyy.txt', 'w') { |f| f.puts @output_framescores } }
    #   end
    # end

    def has_only_numeric_elements in_array
      in_array.each do |i|
        return false if not i.is_a? Integer
      end
      return true
    end
    
    def is_nonempty_with_maxlen in_array, maxlen
      if in_array.length > maxlen || in_array.length == 0
        return false
      end
      return true
    end
    
    def validate_input_frames
      unless @input_frames.is_a?(Array)
        @errmsg = "Input is not an array"
        return false
      end
      
      # input array shd be length 10
      unless @input_frames.length == 10
        @errmsg = "Input array must be 10 units long"
        return false
      end
      
      # loop thru firstframe to ninthframe
      # at i frame
      #   verify
      #     frame has either 1 integer entry ( [10] )
      #                   or 2 integer entries ( [x,y] where -1<x<10, -1<y<11, x+y < 11 )
      @input_frames[0..8].each_with_index do |i, index|
        unless has_only_numeric_elements i
          @errmsg = "Subarray no. #{index + 1} must contain only integer entries"
          return false
        end
        
        unless is_nonempty_with_maxlen i, 2
          @errmsg = "Subarray no. #{index + 1} must not be empty and length must not exceed 2"
          return false
        end
        
        case i.length
        when 1
          # subarray with only one entry must have entry 10
          if i[0] != 10
            @errmsg = "Subarray no. #{index + 1} with single entry must have value 10"
            return false
          end
        
        when 2
          # subarray with 2 integer entries ( [x,y] where -1<x<10, -1<y<11, x+y < 11 )
         
          throw1 = i[0]
          throw2 = i[1]
          
          if ( throw1 <= -1) || ( throw1 >= 10)
            @errmsg = "Subarray no. #{index + 1} : Invalid throw no. 1"
            return false
          end
          
          if ( throw2 <= -1) || ( throw2 >= 11)
            @errmsg = "Subarray no. #{index + 1} : Invalid throw no. 2"
            return false
          end
          
          if ( throw1 + throw2 >= 11)
            @errmsg = "Subarray no. #{index + 1} : Throws 1 and 2 together must not exceed 10 pins"
            return false
          end
          
        else
          # shouldn't reach here
          @errmsg = "Subarray must be length 1 or 2"
          return false
        end
        
      end
      
      # loop thru tenthframe
      # at i frame
      #   verify
      #     frame cannot have only 1 entry
      #     frame has either 3 integer entries ( [10,x,y] where -1<x<11, -1<y<11)
      #                   or 2 integer entries ( [x,y] where -1<x<10, -1<y<11, x+y < 11 )
      @input_frames[9..9].each do |i|
        unless has_only_numeric_elements i
          @errmsg = "Tenth subarray must contain only integer entries"
          return false
        end
        
        unless is_nonempty_with_maxlen i, 3
          @errmsg = "Tenth subarray must not be empty and length must not exceed 3"
          return false
        end
        
        case i.length
        when 1
          # tenth frame cannot have only 1 entry
          @errmsg = "Tenth subarray cannot have only 1 entry"
          return false
        
        when 2
          # subarray with 2 integer entries ( [x,y] where -1<x<10, -1<y<11, x+y < 11 )
         
          throw1 = i[0]
          throw2 = i[1]
          
          if ( throw1 <= -1) || ( throw1 >= 10)
            @errmsg = "Tenth subarray: Invalid throw no. 1"
            return false
          end
          
          if ( throw2 <= -1) || ( throw2 >= 11)
            @errmsg = "Tenth subarray: Invalid throw no. 2"
            return false
          end
          
          if ( throw1 + throw2 >= 11)
            @errmsg = "Tenth subarray: Throws 1 and 2 together must not exceed 10 pins"
            return false
          end
          
          ###### @errmsg = "#{throw1} eee #{throw2}" ###### dbug
          ###### return false                        ###### dbug
          
        when 3
          # subarray with 3 integer entries ( [10,x,y] where -1<x<11, -1<y<11)
         
          throw1 = i[0]
          throw2 = i[1]
          throw3 = i[2]
          
          if throw1 != 10
            @errmsg = "Tenth subarray: 1st throw of a 3-throws tenth frame must be 10 pins"
            return false
          end
          
          if ( throw2 <= -1) || ( throw2 >= 11)
            @errmsg = "Tenth subarray: Invalid throw for no. 2"
            return false
          end
          
          if ( throw3 <= -1) || ( throw3 >= 11)
            @errmsg = "Tenth subarray: Invalid throw for no. 3"
            return false
          end
        
        else
          # shouldn't reach here
          @errmsg = "Tenth subarray must be length 2 or 3"
          return false
        end
        
      end
      
    end
    
    def compute_cumulative_framescores
      cumulative_framescores = 0
      nxtframethrow1 = 0
      nxtframethrow2 = 0
      nxtnxtframethrow1 = 0
      throw1 = 0
      throw2 = 0
      throw3 = 0
      score = 0
      
      # firstframe to eigthframe
      # note own throw1
      # if STRIKE
      #   examine nxt frame
      #   if nxt frame also STRIKE
      #     score = own10 + nxtframe10 + nxtnxtframethrow1
      #   else
      #     score = own10 + nxtframethrow1 + nxtframethrow2
      #   end
      # else
      #   score = ownthrow1 + ownthrow2
      # end
      @input_frames[0..7].each_with_index do |i, index|
        throw1 = i[0]
        
        if throw1 == STRIKE
          nxtframethrow1 = @input_frames[ index + 1][0]
          
          if nxtframethrow1 == STRIKE
            nxtnxtframethrow1 = @input_frames[ index + 2][0]
            score = STRIKE + STRIKE + nxtnxtframethrow1
          else
            nxtframethrow2 = @input_frames[ index + 1][1]
            score = STRIKE + nxtframethrow1 + nxtframethrow2
          end
          
        else
          throw2 = i[1]
          score = throw1 + throw2
        end
        
        cumulative_framescores += score
        @output_framescores.push cumulative_framescores
        
        # @errmsg = throw1 # dbug
        # return false     # dbug
        
      end
      
      # @errmsg = @output_framescores # dbug
      # return false     # dbug
      
      # Ninth frame
      # note own throw1
      # if STRIKE
      #   examine nxt frame
      #   score = own10 + nxtframethrow1 + nxtframethrow2
      # else
      #   score = ownthrow1 + ownthrow2
      # end
      @input_frames[8..8].each_with_index do |i, index|
        throw1 = i[0]
        
        if throw1 == STRIKE
          nxtframethrow1 = @input_frames[9][0] # @input_frames[9] is the last frame i.e. Frame Ten
          nxtframethrow2 = @input_frames[9][1]
          
          score = STRIKE + nxtframethrow1 + nxtframethrow2
          
        else
          throw2 = i[1]
          score = throw1 + throw2
        end
        
        cumulative_framescores += score
        @output_framescores.push cumulative_framescores
        
        # @errmsg = @output_framescores # dbug
        # return false     # dbug
        
      end
      
      # @errmsg = @output_framescores # dbug
      # return false     # dbug
      
      # Tenth frame
      # score = ownthrow1 + ownthrow2
      # or
      # score = ownthrow1 + ownthrow2 + ownthrow3
      @input_frames[9..9].each_with_index do |i, index|
        throw1 = i[0]
        throw2 = i[1]
        
        if i.length == 3
          throw3 = i[2]
          score = throw1 + throw2 + throw3
        else
          score = throw1 + throw2
        end
        
        cumulative_framescores += score
        @output_framescores.push cumulative_framescores
        
      end
      
      # @errmsg = @output_framescores # dbug
      # return false     # dbug
      
    end

end
