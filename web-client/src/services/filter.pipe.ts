import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'filter'
})

export class FilterPipe implements PipeTransform {
  
  transform(items: any[], searchText: string): any[] {
        if(!items) return [];
        if(!searchText) return items;
        
        searchText = searchText.toLowerCase();

        if(items[0].username !== undefined){
            return items.filter( it => {
                return it.username.toLowerCase().includes(searchText);
            });
        }
        else {
            return items.filter( it => {
                if(it.title.toLowerCase().includes(searchText) || it.authorName.toLowerCase().includes(searchText)) {
                    return it;
                }
            });
        }
    }
}