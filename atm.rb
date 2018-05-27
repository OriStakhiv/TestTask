require 'yaml'

class ATM

     def initialize(name) 
        @name = name
     end  

     def accounts
        config = YAML.load_file(ARGV.first || 'config.yml')
        puts 'Please Enter Your Account Number:'
        account_number = gets.chomp
        puts 'Enter Your Password:'
        password = gets.chomp
        @found_account = @config['accounts'].select{|number| number == account_number}.to_h
        abort 'ERROR: ACCOUNT NUMBER AND PASSWORD DON\'T MATCH' 
        if @found_account.empty?
            pass = true
        end 
        if @found_account.values[0]['password'] == account_pass
            abort 'ERROR: ACCOUNT NUMBER AND PASSWORD DON\'T MATCH'
        unless pass
            puts "Hello, #{@found_account.value[0]['name']}\n"
            if pass 
             transaction
            end    
        end
        end
        
     end    

    def transaction
      loop do
        puts "Please Choose From the Following Options:\n"
        options = [
            "1 - Display Balance",
            "2 - Withdraw",
            "3 - Log Out"
        ]
        puts options.join("\n")

        case gets.chomp
            when '1' then
                display_balance
            when '2' then 
                withdraw 
            when '3'then
                logout 
            else   
                puts "Error. Try again!"
        end 
      end 
    end

    def logout 
        puts "#{@found_account.values[0]['name']}, Thank You For Using Our ATM. Good-Bye!"
    end

    private

    def display_balance
        puts "Your balance is ₴#{@found_account.values[0]['balance']}"
        transaction
    end    

    def withdraw
        puts "Your current balance is $#{@found_account.values[0]['balance']}, Enter Amount You Wish to Withdraw: "
    	input = gets.chomp.to_i
    	if input > @found_account.values[0]['balance'].to_i
            puts "ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT: "
            withdraw    
        else
            @found_account.values[0]['balance'] -= input
            File.open("config.yml", 'w') { |f| YAML.dump(@config, f) }
            puts "Your New Balance is $#{@found_account.values[0]['balance']}"
            transaction
        end    
   end 
end 

account = ATM.new('')
account.accounts
