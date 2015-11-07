$(function() {
            // uuid generate utility method 
            function uuid() {
                var uuid = "", i, random;
            	for (i = 0; i < 32; i++) {
        			random = Math.random() * 16 | 0;
        			
        			if (i == 8 || i == 12 || i == 16 || i == 20) {
        				uuid += "-"
        			}
        			uuid += (i == 12 ? 4 : (i == 16 ? (random & 3 | 8) : random)).toString(16);
        		}
        		return uuid;
        	}
        	
            var account = {};
            $.getJSON("signup.php?callback=?",{unique:uuid()},
                function(data, status){
                    account = data;
        
        			console.log(account);
                    
        			if( account['status'] == 'createAccount'){
        				$('div#message').html( '<div>ようこそ' + account['email'] + 'さん。アカウント作成のためにパスワードを入力してください。</div>' );
        			}else if( account['status'] == 'succeedAccount' ){
	        			$('div#message').html( '<div>' + account['email'] + 'さん。アカウント作成が完了しました。以下のURLをタップしてアプリケーションを起動してください。<a href="' + account['loginURL'] + '">' + account['loginURL'] + '</a></div>' );
        			}else if( account['status'] == 'failureExistUser' ){
	        			$('div#message').html( '<div>すでに追加済みのユーザです。以下のURLをタップしてアプリケーションを起動してください。<a href="' + account['loginURL'] + '">' + account['loginURL'] + '</a></div>' );
        			}
            	}
            );
        
        	$('input#submitCreateUserAccount').click(function() {
                if( $("input#password").val().length <= 0 ){
                    alert("パスワードを入力してください。");
                    return false;
                }
            
                if( $("input#password").val().length < 6 ){
                    alert("6文字以上。英数を組み合わせたパスワードを指定してください。");
                    return false;
                }
            
                if( $("input#confirmpassword").val().length <= 0 ){
                    alert("パスワード(確認)を入力してください。");
                    return false;
                }
            
                var password = $("input#password").val().trim();
                var confirmPassword = $("input#confirmpassword").val().trim();
                if( password != confirmPassword ){
                    alert("パスワードと確認パスワードの内容が異なります。");
                    return false;
                }
                return true;
            });
        });