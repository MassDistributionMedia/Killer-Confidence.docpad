$(window).scroll(function () {       

        if ($(this).scrollTop() > 649) {
        $('#upTop').css('opacity','1');
    } else{
        $('#upTop').css('opacity','0');
    }

});

// page fade effect - this simple trick first waits for page to load(images, content) and after it's loaded fades it. You can remove it by deleting this section.
// read documentation
$(document).ready(function() {
    $('#page').fadeTo(1500, 1);
});

