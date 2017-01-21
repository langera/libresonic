/*
 This file is part of Libresonic.

 Libresonic is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Libresonic is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Libresonic.  If not, see <http://www.gnu.org/licenses/>.

 Copyright 2016 (C) Libresonic Authors
 Based upon Subsonic, Copyright 2009 (C) Sindre Mehus
 */
package org.libresonic.player.domain;

import org.libresonic.player.service.SearchService;

import java.io.File;
import java.util.*;

import static java.util.Collections.emptyList;

/**
 * The outcome of a search.
 *
 * @author Sindre Mehus
 * @see SearchService#search
 */
public class SearchResult {

    private static final int MAX_LIMIT = 30;
    private final Map<File, MediaFile> mediaFilesByFileMap = new HashMap<>();
    private final List<Artist> artists = new ArrayList<Artist>();
    private final List<Album> albums = new ArrayList<Album>();

    private int offset;
    private int totalHits;
    private final int limit;

    public SearchResult() {
        this(Integer.MAX_VALUE);
    }

    public SearchResult(final int limit) {
        this.limit = Math.min(limit, MAX_LIMIT);
    }

    public List<MediaFile> getMediaFiles() {
        final ArrayList<MediaFile> mediaFiles = new ArrayList<>(mediaFilesByFileMap.values());
        mediaFiles.sort(new Comparator<MediaFile>() {
            @Override
            public int compare(MediaFile o1, MediaFile o2) {
                final float diff = o1.getScore() - o2.getScore();
                return diff == 0 ? 0 : diff < 0 ? 1 : -1;
            }
        });
        int toIndex = Math.min(mediaFiles.size(), offset + limit);
        if (toIndex == 0) {
            return emptyList();
        }
        int fromIndex = Math.min(offset, toIndex - 1);
        return mediaFiles.subList(fromIndex, toIndex);
    }

    public List<Artist> getArtists() {
        return artists;
    }

    public List<Album> getAlbums() {
        return albums;
    }

    public int getOffset() {
        return offset;
    }

    public void setOffset(int offset) {
        this.offset = offset;
    }

    public int getTotalHits() {
        return totalHits;
    }

    public void setTotalHits(int totalHits) {
        this.totalHits = totalHits;
    }

    public void addMediaFile(final MediaFile mediaFile) {
        final MediaFile current = mediaFilesByFileMap.putIfAbsent(mediaFile.getFile(), mediaFile);
        if (current != null) {
            current.setScore(Math.max(current.getScore(), mediaFile.getScore()));
        }
    }

    public Set<File> getFiles() {
        return mediaFilesByFileMap.keySet();
    }

    public int getSize() {
        return Math.min(mediaFilesByFileMap.size(), limit);
    }

}